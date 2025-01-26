import 'package:flutter/material.dart';
import 'package:nexus_chats/frontend/providers.dart';
import 'package:nexus_chats/backend/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/controllers/chat_controller.dart';
import 'package:nexus_chats/backend/controllers/user_controller.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';

class AddPrivateChatForm extends ConsumerStatefulWidget {
  const AddPrivateChatForm({super.key});

  @override
  ConsumerState<AddPrivateChatForm> createState() => _AddPrivateChatFormState();
}

class _AddPrivateChatFormState extends ConsumerState<AddPrivateChatForm> {
  final TextEditingController _otherUserIdController = TextEditingController();
  Users? user;

  Future<void> _fetchUserProfile(String userId) async {
    final userController = ref.read(userControllerProvider);
    user = await userController.fetchUser(userId);

    setState(() {});
  }

  Future<void> _registerChat() async {
    final currentUser = ref.watch(userProvider);
    final chatController = ref.read(chatControllerProvider);
    await chatController.registerChat(members: [
      {user!.id: 'member'},
      {currentUser!.id: 'member'}
    ], profile: user!.profileLink, chatname: user!.username, group: false);

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
            "Add Private Chat",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'montaga'),
          ),
          const SizedBox(height: 16),
          AnimatedTextField(
              label: "Other User's Id",
              icon: Icons.person_3,
              obscureText: false,
              controller: _otherUserIdController),
          const Spacer(),
          const Center(child: CircularProgressIndicator()),
          const Spacer(),
          AnimatedButton(
              onPressed: () async {
                await _fetchUserProfile(_otherUserIdController.text.trim());
                _registerChat();
              },
              displayText: "Register Private Chat",
              fontFamily: 'montaga')
        ],
      ),
    );
  }
}
