import 'chat_card.dart';
import 'package:flutter/material.dart';
import 'package:nexus_chats/backend/models/chats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/pages/add_chat_page.dart';
import 'package:nexus_chats/frontend/components/animated_circle_icon_button.dart';

class ChatList extends ConsumerWidget {
  const ChatList({
    super.key,
    required this.chats,
  });

  final List<Chats> chats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSmallScreen = MediaQuery.of(context).size.width < 500;

    return Center(
      // Center the chat list on larger screens
      child: SizedBox(
        width: isSmallScreen ? MediaQuery.of(context).size.width : 500,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0), // Avoid overlap
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ChatCard(
                      chat: chat,
                      lastMessage: "No messages yet",
                      unreadMessages: 0,
                      lastArrival: DateTime.now(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 80,
              right: 30,
              child: AnimatedCircleIconButton(
                radius: 35,
                icon: Icons.app_registration,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddChatPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
