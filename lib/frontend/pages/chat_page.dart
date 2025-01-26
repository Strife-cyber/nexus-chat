import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nexus_chats/backend/models/chats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/frontend/chat_components/chat_list.dart';
import 'package:nexus_chats/backend/controllers/chat_controller.dart';
import 'package:nexus_chats/frontend/components/animated_text_field.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  List<Chats> chats = [];
  List<Chats> filteredChats = [];

  final connectionChecker = InternetConnectionChecker.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Stream<List<Chats>> filteredStream(String query, Stream<List<Chats>> stream) {
    return stream.map((chats) {
      if (query.isEmpty) {
        return chats;
      }
      return chats
          .where((chat) =>
              chat.chatname!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ref.read(chatControllerProvider);
    final isSmallScreen = MediaQuery.of(context).size.width < 500;

    return SizedBox(
      width: isSmallScreen ? MediaQuery.of(context).size.width : 500,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedTextField(
                label: 'Search Chats...',
                icon: Icons.search_sharp,
                obscureText: false,
                controller: _searchController),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Stack(
            children: [
              StreamBuilder<List<Chats>>(
                  stream: filteredStream(
                      _searchController.text, chatController.streamChats()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.pink[400]!,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print(snapshot.stackTrace);
                      }
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Check the type at runtime
                      return const Center(
                        child: Text(
                          "No private chats available.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      );
                    }

                    final updatedChats = snapshot.data!;
                    _updateChatList(updatedChats);

                    return ChatList(chats: filteredChats);
                  })
            ],
          ))
        ],
      ),
    );
  }

  void _updateChatList(List<Chats> updatedChats) {
    final currentFilteredChats = List<Chats>.from(filteredChats);

    final addedChats = updatedChats
        .where(
            (chat) => !currentFilteredChats.any((c) => c.chatId == chat.chatId))
        .toList();

    final removedChats = filteredChats
        .where((chat) => !updatedChats.any((c) => c.chatId == chat.chatId))
        .toList();

    for (var chat in removedChats) {
      final index = filteredChats.indexWhere((c) => c.chatId == chat.chatId);
      if (index >= 0) {
        filteredChats.removeAt(index);
      }
    }

    for (var chat in addedChats) {
      filteredChats.add(chat);
    }
  }
}
