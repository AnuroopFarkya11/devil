

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:logger/logger.dart';

class FireStoreRepository extends FireStoreBaseRepository{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  /// Adds a document to the specified [collectionPath] with the given [data].
  @override
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
      _logger.i('Document added to $collectionPath');
    } catch (e) {
      _logger.e('Error adding document: $e');
    }
  }

  /// Retrieves a document from the specified [collectionPath] with the given [docId].
  @override
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionPath).doc(docId).get();
      _logger.i('Document retrieved from $collectionPath/$docId');
      return doc;
    } catch (e) {
      _logger.e('Error getting document: $e');
      rethrow;
    }
  }

  /// Updates a document in the specified [collectionPath] with the given [docId] and [data].
  @override
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      _logger.i('Document updated in $collectionPath/$docId');
    } catch (e) {
      _logger.e('Error updating document: $e');
      rethrow;

    }
  }

  /// Deletes a document from the specified [collectionPath] with the given [docId].
  @override
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      _logger.i('Document deleted from $collectionPath/$docId');
    } catch (e) {
      _logger.e('Error deleting document: $e');
      rethrow;

    }
  }

  /// Returns a stream of documents from the specified [collectionPath].
  @override
  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    _logger.i('Subscribing to collection stream from $collectionPath');
    return _firestore.collection(collectionPath).snapshots();
  }

  /// Adds a document with a custom [docId] to the specified [collectionPath] with the given [data].
  @override
  Future<void> addDocumentWithId(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set(data);
      _logger.i('Document with ID $docId added to $collectionPath');
    } catch (e) {
      _logger.e('Error adding document with ID: $e');
      rethrow;

    }
  }

  /// Queries a collection with the specified [filters] in the [collectionPath].
  @override
  Future<QuerySnapshot> queryCollection(String collectionPath, Map<String, dynamic> filters) async {
    try {
      CollectionReference collection = _firestore.collection(collectionPath);
      Query query = collection;

      filters.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });

      QuerySnapshot result = await query.get();
      _logger.i('Collection $collectionPath queried with filters $filters');
      return result;
    } catch (e) {
      _logger.e('Error querying collection: $e');
      rethrow;
    }
  }

  /// Performs batch write operations specified in [operations].
  @override
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    WriteBatch batch = _firestore.batch();

    for (var operation in operations) {
      String action = operation['action'];
      String collectionPath = operation['collectionPath'];
      String docId = operation['docId'];
      Map<String, dynamic> data = operation['data'];

      DocumentReference docRef = _firestore.collection(collectionPath).doc(docId);

      switch (action) {
        case 'add':
          batch.set(docRef, data);
          break;
        case 'update':
          batch.update(docRef, data);
          break;
        case 'delete':
          batch.delete(docRef);
          break;
      }
    }

    try {
      await batch.commit();
      _logger.i('Batch write committed with operations: $operations');
    } catch (e) {
      _logger.e('Error performing batch write: $e');
    }
  }

  /// Runs a Firestore transaction using the provided [transactionHandler].
  @override
  Future<void> runTransaction(Function(Transaction) transactionHandler) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await transactionHandler(transaction);
      });
      _logger.i('Transaction run successfully');
    } catch (e) {
      _logger.e('Error running transaction: $e');
    }
  }

  /// Retrieves a paginated collection from the specified [collectionPath] with the given [limit].
  /// Optionally, you can provide a [startAfter] document to start the pagination from.
  @override
  Future<QuerySnapshot> getPaginatedCollection(String collectionPath, int limit, {DocumentSnapshot? startAfter}) async {
    try {
      Query query = _firestore.collection(collectionPath).limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      QuerySnapshot result = await query.get();
      _logger.i('Paginated collection retrieved from $collectionPath with limit $limit');
      return result;
    } catch (e) {
      _logger.e('Error getting paginated collection: $e');
      rethrow;
    }
  }

  /// Retrieves an ordered collection from the specified [collectionPath] ordered by [orderByField].
  /// Optionally, you can specify whether the order should be [descending].
  @override
  Future<QuerySnapshot> getCollectionOrdered(String collectionPath, String orderByField, {bool descending = false}) async {
    try {
      Query query = _firestore.collection(collectionPath).orderBy(orderByField, descending: descending);
      QuerySnapshot result = await query.get();
      _logger.i('Ordered collection retrieved from $collectionPath ordered by $orderByField');
      return result;
    } catch (e) {
      _logger.e('Error getting ordered collection: $e');
      rethrow;
    }
  }

  /// Performs a compound query with multiple [conditions] in the specified [collectionPath].
  @override
  Future<QuerySnapshot> getCompoundQuery(String collectionPath, Map<String, dynamic> conditions) async {
    try {
      Query query = _firestore.collection(collectionPath);

      conditions.forEach((field, value) {
        if (value is List) {
          query = query.where(field, isEqualTo: value[1]);
        } else {
          query = query.where(field, isEqualTo: value);
        }
      });

      QuerySnapshot result = await query.get();
      _logger.i('Compound query performed on $collectionPath with conditions $conditions');
      return result;
    } catch (e) {
      _logger.e('Error performing compound query: $e');
      rethrow;
    }
  }

  /// Checks if a document exists at the specified [collectionPath] and [docId].
  @override
  Future<bool> documentExists(String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionPath).doc(docId).get();
      bool exists = doc.exists;
      _logger.i('Document existence checked at $collectionPath/$docId: $exists');
      return exists;
    } catch (e) {
      _logger.e('Error checking document existence: $e');
      rethrow;
    }
  }

  /// Adds a list of documents to the specified [collectionPath] using a batch operation.
  @override
  Future<void> addDocumentsInBatch(String collectionPath, List<Map<String, dynamic>> documents) async {
    WriteBatch batch = _firestore.batch();

    for (var data in documents) {
      DocumentReference docRef = _firestore.collection(collectionPath).doc();
      batch.set(docRef, data);
    }

    try {
      await batch.commit();
      _logger.i('Documents added in batch to $collectionPath');
    } catch (e) {
      _logger.e('Error adding documents in batch: $e');
      rethrow;

    }
  }

  /// Retrieves the count of documents in the specified [collectionPath].
  @override
  Future<int> getDocumentCount(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionPath).get();
      int count = querySnapshot.docs.length;
      _logger.i('Document count for $collectionPath: $count');
      return count;
    } catch (e) {
      _logger.e('Error getting document count: $e');
      rethrow;
    }
  }

}
