import 'package:uuid/uuid.dart';
import 'package:sembast/sembast_io.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus_chats/frontend/providers.dart';
import 'package:nexus_chats/backend/models/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/functions/hashing.dart';
import 'package:nexus_chats/backend/managers/file_management.dart';
import 'package:nexus_chats/backend/managers/firestore_manager.dart';
import 'package:nexus_chats/backend/managers/sembast_management.dart';

final userControllerProvider = Provider<UserController>((ref) => UserController(
    fileManagement: FileManagement(),
    firestoreManager: FirestoreManager(),
    sembastManagement: SembastManagement(),
    ref: ref));

class UserController {
  final FileManagement fileManagement;
  final FirestoreManager firestoreManager;
  final SembastManagement sembastManagement;
  final Ref ref;

  UserController({
    required this.fileManagement,
    required this.firestoreManager,
    required this.sembastManagement,
    required this.ref,
  });

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required Uint8List? profile,
    required String about,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();
    String? profileId;

    try {
      if (profile != null) {
        profileId = await fileManagement.uploadProfile(profile, 'profile_$id');
      }

      final user = Users(
        id: id,
        username: username,
        email: email,
        password: hashString(password),
        profileLink: profileId,
        about: about,
      );

      await firestoreManager.createDocument('users', user.toMap());
      await sembastManagement.createDocument('users', user.toMap());

      ref.read(userProvider.notifier).setUser(user); // Correct usage
    } catch (e) {
      if (kDebugMode) print('Error during user registration: $e');
    }
  }

  Future<bool> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final filter = Filter.and([
        Filter.equals('email', email),
        Filter.equals('password', password),
      ]);

      final records = await sembastManagement.queryDocuments('users', filter);

      if (records.isNotEmpty) {
        final user = Users.fromMap(records.first);
        ref.read(userProvider.notifier).setUser(user); // Correct usage

        return true;
      } else {
        final userList = await firestoreManager.queryDocuments(
          'users',
          (collectionRef) => collectionRef.where('email', isEqualTo: email),
        );

        if (userList.isNotEmpty) {
          final userMap = userList.first;
          if (userMap['password'] == hashString(password)) {
            final user = Users.fromMap(userMap);
            ref.read(userProvider.notifier).setUser(user); // Correct usage
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error during login: $e');
    }

    return false;
  }

  Future<void> updateAccount({
    required String? username,
    required String? email,
    required String? password,
    required Uint8List? profile,
    required String? about,
  }) async {
    try {
      final user = ref.read(userProvider);

      // Fetch all documents in the "users" collection
      final docs = await firestoreManager.getDocs('users');

      // Find the document ID of the user with the matching email
      String? docId;
      for (var doc in docs) {
        final data = (await doc.get()).data() as Map<String, dynamic>;
        if (data['email'] == user!.email) {
          docId = doc.id;
          break;
        }
      }

      if (docId == null) {
        throw 'User not found in Firestore';
      }

      // Create updated user data
      final updatedUser = user!.copyWith(
        username: username ?? user.username,
        email: email ?? user.email,
        password: password != null ? hashString(password) : user.password,
        about: about ?? user.about,
        profileLink: profile != null
            ? await fileManagement.uploadProfile(profile, 'profile_$docId')
            : user.profileLink,
      );

      // Update Firestore document
      await firestoreManager.updateDocument(
        'users',
        docId,
        updatedUser.toMap(),
      );

      // Update local storage (Sembast)
      await sembastManagement.updateDocument(
        'users',
        docId,
        updatedUser.toMap(),
      );

      // Update the user provider
      ref.read(userProvider.notifier).setUser(updatedUser);
    } catch (e) {
      if (kDebugMode) print('Error during account update: $e');
      throw 'Failed to update account. Please try again later.';
    }
  }

  Future<Users?> fetchUser(String id) async {
    final filter = Filter.equals('id', id);

    // check if sembast has this guy
    final records = await sembastManagement.queryDocuments('users', filter);

    if (records.isNotEmpty) {
      return Users.fromMap(records.first);
    } else {
      // now to firebase
      final userList = await firestoreManager.queryDocuments(
        'users',
        (collectionRef) => collectionRef.where('id', isEqualTo: id),
      );
      if (userList.isNotEmpty) {
        return Users.fromMap(userList.first);
      }
    }
    return null;
  }
}
