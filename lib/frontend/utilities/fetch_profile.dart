import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_chats/backend/managers/file_management.dart';

Future<Uint8List> fetchProfile(WidgetRef ref, String profileLink) async {
  // Ensure that user is not null
  final filemanager = FileManagement();

  // Fetch the profile if the profileLink is not null
  return await filemanager.getProfile(profileLink);
}
