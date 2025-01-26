import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nexus_chats/backend/models/chats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/utilities/date_time_info.dart';
import 'package:nexus_chats/frontend/utilities/fetch_profile.dart';

class ChatCard extends ConsumerStatefulWidget {
  const ChatCard(
      {super.key,
      required this.chat,
      required this.lastMessage,
      required this.unreadMessages,
      required this.lastArrival});

  final Chats chat;
  final String lastMessage;
  final int unreadMessages;
  final DateTime lastArrival;

  @override
  ConsumerState<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends ConsumerState<ChatCard> {
  Uint8List? profile;
  DateTimeInfo? lastTransaction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialize();
  }

  void initialize() async {
    if (widget.chat.profile != '') {
      profile = await fetchProfile(ref, widget.chat.profile);
    }
    lastTransaction = parseDateTimeString(widget.lastArrival.toIso8601String());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.pinkAccent[200]!,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[400],
              backgroundImage: profile != null ? MemoryImage(profile!) : null,
              child: profile == null ? const Icon(Icons.person) : null,
            ),
          ),
          SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.chatname!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'montaga'),
                      overflow: TextOverflow.clip),
                  const SizedBox(height: 10),
                  Text(widget.lastMessage,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                          fontFamily: 'montaga'),
                      overflow: TextOverflow.clip)
                ],
              )),
          SizedBox(
              width: 80,
              child: Column(
                children: [
                  Text(
                      '${lastTransaction?.hour}:${lastTransaction?.minute} ${lastTransaction?.period}',
                      style: TextStyle(
                          color: Colors.pink[200],
                          fontFamily: 'montaga',
                          fontSize: 10)),
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.pink[200],
                    child: Text(
                      widget.unreadMessages.toString(),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
