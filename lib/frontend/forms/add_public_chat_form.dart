import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_chats/backend/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/controllers/chat_controller.dart';
import 'package:nexus_chats/backend/controllers/user_controller.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';
import 'package:nexus_chats/frontend/components/multiselect_dropdown.dart';
import 'package:nexus_chats/frontend/components/animated_circle_avatar.dart';
import 'package:nexus_chats/frontend/providers.dart';

class AddPublicChatForm extends ConsumerStatefulWidget {
  const AddPublicChatForm({super.key});

  @override
  ConsumerState<AddPublicChatForm> createState() => _AddPublicChatFormState();
}

class _AddPublicChatFormState extends ConsumerState<AddPublicChatForm> {
  final TextEditingController _chatNameController = TextEditingController();
  List<String> _members = [];
  Set<Users?> myContacts = {};
  Uint8List? _groupProfile;
  List<Users?> selectedMembers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectMembers();
  }

  Future<void> _selectMembers() async {
    final userController = ref.read(userControllerProvider);
    final chatController = ref.read(chatControllerProvider);
    final user = ref.read(userProvider);

    // Fetch contacts and user data
    _members = await chatController.getAllValidContacts();
    for (var member in _members) {
      myContacts.add(await userController.fetchUser(member));
    }
    myContacts.remove(user);

    setState(() {}); // Refresh UI after members are loaded
  }

  void _onMemberSelected(Users? user) {
    setState(() {
      selectedMembers.add(user!);
    });
  }

  void _removeSelectedMember(Users user) {
    setState(() {
      selectedMembers.remove(user);
    });
  }

  Future<void> _registerChat() async {
    final chatName = _chatNameController.text.trim();

    // Validate inputs
    if (chatName.isEmpty || selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide all required data.')),
      );
      return;
    }

    final chatController = ref.read(chatControllerProvider);
    final user = ref.read(userProvider);

    // let us contruct the member list
    List<Map<String, String>> groupMembers = [];
    groupMembers.add({user!.id: 'admin'});

    for (var member in selectedMembers) {
      groupMembers.add({member!.id: 'member'});
    }

    await chatController.registerChat(
        members: groupMembers,
        group: true,
        chatname: chatName,
        groupProfile: _groupProfile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New Chat Registered.',
                style: TextStyle(fontFamily: 'pacifico'))),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Add Group Chat",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
                fontFamily: 'montaga'),
          ),
          const SizedBox(height: 20),
          AnimatedCircleAvatar(
            onImagePicked: (imageBytes) {
              _groupProfile = imageBytes;
            },
          ),
          const SizedBox(height: 16),
          AnimatedTextField(
              label: 'Group Name',
              icon: Icons.group,
              obscureText: false,
              controller: _chatNameController),
          const SizedBox(height: 16),
          MultiSelectDropdown(
            options: myContacts.toList(),
            selectedItems: selectedMembers,
            onSelected: _onMemberSelected,
          ),
          const SizedBox(height: 8),
          if (selectedMembers.isNotEmpty)
            Wrap(
              spacing: 8.0,
              children: selectedMembers.map((contact) {
                return Chip(
                  label: Text(contact!.username),
                  backgroundColor: Colors.deepPurpleAccent,
                  labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
                  deleteIcon: const Icon(Icons.remove_circle,
                      color: Colors.deepPurpleAccent),
                  onDeleted: () => _removeSelectedMember(contact),
                );
              }).toList(),
            ),
          const SizedBox(height: 25),
          AnimatedButton(
              onPressed: _registerChat,
              displayText: 'Register Group Chat',
              fontFamily: 'montaga')
        ],
      ),
    );
  }
}
