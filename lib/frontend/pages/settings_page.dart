import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/controllers/user_controller.dart';
import 'package:nexus_chats/backend/models/users.dart';
import 'package:nexus_chats/frontend/components/animated_button.dart';
import 'package:nexus_chats/frontend/components/animated_circle_avatar.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';
import 'package:nexus_chats/frontend/providers.dart';
import 'package:nexus_chats/frontend/utilities/fetch_profile.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final List<TextEditingController> controllers =
      List.generate(3, (index) => TextEditingController());

  bool _isChanged = false;
  Users? user;
  Uint8List? profile;

  @override
  void dispose() {
    super.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void _onChange() {
    setState(() {
      _isChanged = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (user == null) {
      user = ref.watch(userProvider);

      // Set initial values for controllers
      if (user != null) {
        controllers[0].text = user!.username;
        controllers[1].text = user!.email;
        controllers[2].text = user!.about;
      }

      // Load profile image
      fetchImage();
    }
  }

  void fetchImage() async {
    if (user?.profileLink != null) {
      profile = await fetchProfile(ref, user!.profileLink!);
      setState(() {}); // Update the UI when the profile is loaded
    }
  }

  Future<void> _saveChanges() async {
    final userController = ref.read(userControllerProvider);

    setState(() {
      _isChanged = false;
    });

    await userController.updateAccount(
      username: controllers[0].text,
      email: controllers[1].text,
      password: null,
      profile: profile,
      about: controllers[2].text,
    );

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Changes saved successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 50 : 16, vertical: 16),
        child: ListView(
          children: [
            AnimatedCircleAvatar(
              onImagePicked: (Uint8List? image) {
                profile = image;
                setState(() {
                  _isChanged = true;
                });
              },
              initialProfile: profile,
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            // Username Field
            _buildTextField(
                label: "Username",
                controller: controllers[0],
                icon: Icons.person),
            const SizedBox(height: 10),
            // Email Field
            _buildTextField(
                label: "Email", controller: controllers[1], icon: Icons.email),
            const SizedBox(height: 10),
            // About Field
            _buildTextField(
                label: "About", controller: controllers[2], icon: Icons.info),
            const SizedBox(height: 10),
            // Disable password change (no field for password)
            const ListTile(
              title: Text(
                "Password (Cannot be changed)",
                style: TextStyle(color: Colors.grey, fontFamily: 'pacifico'),
              ),
            ),

            const SizedBox(height: 10),

            // Show the Save Button if data is changed
            if (_isChanged)
              Center(
                  child: AnimatedButton(
                      onPressed: _saveChanges,
                      displayText: 'Save Changes',
                      fontFamily: 'montaga'))
          ],
        ));
  }

  // Reusable method to create text fields with proper styling
  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      required IconData icon}) {
    return AnimatedTextField(
      controller: controller,
      label: label,
      icon: icon,
      obscureText: false,
      onChange: (value) => _onChange(),
    );
  }
}
