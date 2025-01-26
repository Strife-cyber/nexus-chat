import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/models/users.dart';

// StateNotifier for user management
class UserNotifier extends StateNotifier<Users?> {
  UserNotifier() : super(null); // Initial state is null (no user logged in)

  // Method to set the user
  void setUser(Users user) {
    state = user;
  }

  // Method to clear the user (e.g., on logout)
  void clearUser() {
    state = null;
  }

  Users? getUser() {
    return state;
  }
}

// Create a provider for the UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, Users?>((ref) {
  return UserNotifier();
});
