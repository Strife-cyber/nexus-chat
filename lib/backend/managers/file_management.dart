import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:nexus_chats/backend/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileManagement {
  static const String _profileBucket = '6781492c001143f198b0';
  static const String _attachmentBucket = '67814954003b09c00949';
  static const String _statusBucket = '678149680032ecc6af9c';

  final ProviderContainer _container;

  FileManagement([ProviderContainer? container])
      : _container = container ?? ProviderContainer();

  Future<Storage> _getStorage() async {
    final client = await _container.read(appWriteProvider);
    return Storage(client);
  }

  Future<String> _uploadFile(
      {required String bucketId,
      required Uint8List fileBytes,
      required String fileName}) async {
    final storage = await _getStorage();

    final uploadedFile = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
    );

    return uploadedFile.$id;
  }

  Future<Uint8List> _downloadFile(
      {required String bucketId, required String fileId}) async {
    final storage = await _getStorage();

    return await storage.getFileDownload(bucketId: bucketId, fileId: fileId);
  }

  Future<String> uploadProfile(Uint8List fileBytes, String fileName) async {
    return await _uploadFile(
        bucketId: _profileBucket, fileBytes: fileBytes, fileName: fileName);
  }

  Future<Uint8List> getProfile(String fileId) async {
    return await _downloadFile(bucketId: _profileBucket, fileId: fileId);
  }

  Future<String> uploadAttachment(Uint8List fileBytes, String fileName) async {
    return await _uploadFile(
        bucketId: _attachmentBucket, fileBytes: fileBytes, fileName: fileName);
  }

  Future<Uint8List> downloadAttachment(String fileId) async {
    return await _downloadFile(bucketId: _attachmentBucket, fileId: fileId);
  }

  Future<String> uploadStatus(Uint8List fileBytes, String fileName) async {
    return await _uploadFile(
        bucketId: _statusBucket, fileBytes: fileBytes, fileName: fileName);
  }

  Future<Uint8List> downloadStatus(String fileId) async {
    return await _downloadFile(bucketId: _statusBucket, fileId: fileId);
  }
}
