import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_chats/backend/models/chats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/managers/file_management.dart';
import 'package:nexus_chats/backend/managers/firestore_manager.dart';
import 'package:nexus_chats/backend/managers/sembast_management.dart';

final chatControllerProvider = Provider<ChatController>((ref) => ChatController(
    fileManagement: FileManagement(),
    firestoreManager: FirestoreManager(),
    sembastManagement: SembastManagement(),
    ref: ref));

class ChatController {
  final FileManagement fileManagement;
  final FirestoreManager firestoreManager;
  final SembastManagement sembastManagement;
  final Ref ref;

  ChatController({
    required this.fileManagement,
    required this.firestoreManager,
    required this.sembastManagement,
    required this.ref,
  });

  /// Registers a new chat
  Future<void> registerChat({
    required List<Map<String, String>> members,
    String? profile,
    Uint8List? groupProfile,
    String? chatname,
    String? createdBy,
    required bool group,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();

    String? profileId;

    try {
      // If it's a group chat, upload the group profile picture
      if (groupProfile != null) {
        profileId = await fileManagement.uploadProfile(
            groupProfile, 'group_profile_$id');
      }

      // Create a chat object
      final chat = Chats(
        chatId: id,
        members: members,
        profile: group ? profileId! : profile!,
        chatname: chatname,
        createdBy: createdBy,
      );

      // Save chat to Firestore and local storage
      await firestoreManager.createDocument('chats', chat.toMap());
      await sembastManagement.createDocument('chats', chat.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error registering chat: $e');
      }
      throw 'Failed to register chat. Please try again later.';
    }
  }

  /// Updates an existing chat
  Future<void> updateChat({
    required String chatId,
    List<Map<String, String>>? members,
    String? profile,
    Uint8List? groupProfile,
    String? chatname,
    String? createdBy,
    required bool group,
  }) async {
    try {
      // Fetch the existing chat document
      final docs = await firestoreManager.getDocs('chats');

      String? docId;
      for (var doc in docs) {
        final data = (await doc.get()).data() as Map<String, dynamic>;
        if (data['id'] == chatId) {
          docId = doc.id;
          break;
        }
      }

      if (docId == null) {
        throw 'User not found in Firestore';
      }

      // Convert document to Chat model
      final chatData = await firestoreManager.getDocument('chats', docId);
      final existingChat = Chats.fromMap(chatData!);

      // Create an updated chat object
      final updatedChat = existingChat.copyWith(
          members: members ?? existingChat.members,
          chatname: chatname ?? existingChat.chatname,
          createdBy: createdBy ?? existingChat.createdBy,
          profile: group
              ? (profile != null
                  ? await fileManagement.uploadProfile(
                      groupProfile!, 'profile_group_$docId')
                  : existingChat.profile)
              : profile);

      // Update Firestore document
      await firestoreManager.updateDocument(
          'chats', docId, updatedChat.toMap());

      // Update local storage (Sembast)
      await sembastManagement.updateDocument(
          'chats', chatId, updatedChat.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating chat: $e');
      }
      throw 'Failed to update chat. Please try again later.';
    }
  }

  Future<void> deleteChat({required String chatId}) async {
    try {
      final docs = await firestoreManager.getDocs('chats');

      String? docId;
      for (var doc in docs) {
        final data = (await doc.get()).data() as Map<String, dynamic>;
        if (data['id'] == chatId) {
          docId = doc.id;
          break;
        }
      }

      if (docId == null) {
        throw 'User not found in Firestore';
      }

      await firestoreManager.deleteDocument('chats', docId);
      await sembastManagement.deleteDocument('chats', chatId);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<String>> getAllValidContacts() async {
    try {
      final docs = await sembastManagement.getAllDocuments('chats');
      final onlineDocs = await firestoreManager.getAllDocuments('chats');
      Set<String> contacts = {};

      for (var doc in docs) {
        final chat = Chats.fromMap(doc);

        // Iterate over each map in chat.members
        for (var member in chat.members) {
          // Each map contains one key-value pair, so we can get the key
          contacts.add(member.keys.first); // Get the first key of the map
        }
      }

      for (var doc in onlineDocs) {
        final chat = Chats.fromMap(doc);

        // Iterate over each map in chat.members
        for (var member in chat.members) {
          // Each map contains one key-value pair, so we can get the key
          contacts.add(member.keys.first); // Get the first key of the map
        }
      }

      return contacts.toList(); // Return as List<String>
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return []; // Return an empty list in case of an error
    }
  }

  Stream<List<Chats>> streamChats() {
    return firestoreManager.streamCollection('chats').map((snapshot) {
      return snapshot.map((doc) => Chats.fromMap(doc)).toList();
    });
  }
}
