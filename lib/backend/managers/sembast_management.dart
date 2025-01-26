import 'package:sembast/sembast.dart';
import 'package:nexus_chats/backend/init.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SembastManagement {
  final ProviderContainer _container;

  SembastManagement() : _container = ProviderContainer();

  Future<Database> _getDatabase() async {
    return await _container.read(sembastProvider);
  }

  StoreRef<int, Map<String, dynamic>> _getStore(String storeName) {
    return intMapStoreFactory.store(storeName);
  }

  // Create a new document
  Future<void> createDocument(
      String storeName, Map<String, dynamic> data) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);

    await store.add(database, data);
  }

  // Retrieve all documents from a store
  Future<List<Map<String, dynamic>>> getAllDocuments(String storeName) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);

    final snapshots = await store.find(database);

    return snapshots.map((record) => record.value).toList();
  }

  // Retrieve a document by key
  Future<Map<String, dynamic>?> getDocument(String storeName, int key) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);

    final record = await store.record(key).get(database);
    return record;
  }

  // Update a document by key
  Future<void> updateDocument(
      String storeName, String id, Map<String, dynamic> data) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);
    final finder = Finder(filter: Filter.equals('id', id));

    await store.update(database, data, finder: finder);
  }

  // Delete a document by key
  Future<void> deleteDocument(String storeName, String id) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);
    final finder = Finder(filter: Filter.equals('id', id));

    await store.delete(database, finder: finder);
  }

  // Query documents with filters
  Future<List<Map<String, dynamic>>> queryDocuments(
      String storeName, Filter filter) async {
    final database = await _getDatabase();
    final store = _getStore(storeName);

    final finder = Finder(filter: filter);

    final snapshots = await store.find(database, finder: finder);

    return snapshots.map((record) => record.value).toList();
  }

  Stream<List<Map<String, dynamic>>> streamDocuments(String storeName) async* {
    final database = await _getDatabase();
    final store = _getStore(storeName);

    yield* store
        .query() // Create a query without filters
        .onSnapshots(database) // Listen for real-time changes
        .map((snapshots) => snapshots.map((record) => record.value).toList());
  }
}
