import 'package:flutter/material.dart';
import 'package:nexus_chats/frontend/forms/add_public_chat_form.dart';
import 'package:nexus_chats/frontend/forms/add_private_chat_form.dart';

class AddChatPage extends StatelessWidget {
  const AddChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(seconds: 1),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text('Add Chat',
              style: TextStyle(
                  fontFamily:
                      'montaga', // Ensure this font is defined in pubspec.yaml
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          bottom: isDesktop
              ? null
              : const TabBar(
                  labelStyle: TextStyle(
                    fontFamily: 'montaga', // Apply Montaga to Tab label
                    fontSize: 12,
                  ),
                  tabs: [
                    Tab(
                        icon: Icon(Icons.person, size: 12),
                        text: 'Private Chat'),
                    Tab(icon: Icon(Icons.group, size: 12), text: 'Group Chat'),
                  ],
                ),
        ),
        body: isDesktop
            ? const Row(
                children: [
                  Expanded(child: AddPrivateChatForm()),
                  VerticalDivider(width: 1),
                  Expanded(child: AddPublicChatForm()),
                ],
              )
            : const TabBarView(
                children: [
                  AddPrivateChatForm(),
                  AddPublicChatForm(),
                ],
              ),
      ),
    );
  }
}
