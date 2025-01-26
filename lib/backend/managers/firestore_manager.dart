import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {
  FirestoreManager._privateConstructor();

  static final FirestoreManager _instance =
      FirestoreManager._privateConstructor();

  /// Singleton instance
  factory FirestoreManager() {
    return _instance;
  }

  /// Initialize Firestore with persistence
  Future<void> initializeFirestore() async {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, // Enable offline persistence
      cacheSizeBytes:
          Settings.CACHE_SIZE_UNLIMITED, // Optional: Unlimited cache
    );
  }

  /// Create a document in a collection
  Future<void> createDocument(
      String collection, Map<String, dynamic> data) async {
    try {
      final docRef = FirebaseFirestore.instance.collection(collection).doc();
      await docRef.set(data);
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  /// Retrieve all documents from a collection
  Future<List<Map<String, dynamic>>> getAllDocuments(String collection) async {
    try {
      final snapshots =
          await FirebaseFirestore.instance.collection(collection).get();
      return snapshots.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to retrieve documents: $e');
    }
  }

  /// Retrieve a single document by ID
  Future<Map<String, dynamic>?> getDocument(
      String collection, String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .get();
      return docSnapshot.exists ? docSnapshot.data() : null;
    } catch (e) {
      throw Exception('Failed to retrieve document: $e');
    }
  }

  /// Update an existing document
  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// Delete a document by ID
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Query documents with filters
  Future<List<Map<String, dynamic>>> queryDocuments(String collection,
      Query Function(CollectionReference) queryBuilder) async {
    try {
      // Get the collection reference
      final collectionRef = FirebaseFirestore.instance.collection(collection);

      // Apply the query filters provided by the queryBuilder function
      final query = queryBuilder(collectionRef);

      // Get the query results
      final querySnapshots = await query.get();

      return querySnapshots.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to query documents: $e');
    }
  }

  Future<List<DocumentReference>> getDocs(String collection) async {
    // Fetch all documents from the specified collection
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();

    // Return a list of DocumentReference objects
    return snapshot.docs.map((doc) => doc.reference).toList();
  }

  Stream<List<Map<String, dynamic>>> streamCollection(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots() // This returns a Stream<QuerySnapshot>
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return {
                ...doc.data(), // Cast data to a map
                'docId': doc.id, // Add the document ID
              };
            }).toList()); // Convert Iterable to List
  }
}
