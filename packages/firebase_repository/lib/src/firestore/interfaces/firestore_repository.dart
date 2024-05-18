import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FireStoreBaseRepository{
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data);
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId);
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collectionPath, String docId);
  Stream<QuerySnapshot> getCollectionStream(String collectionPath);
  Future<void> addDocumentWithId(String collectionPath, String docId, Map<String, dynamic> data);
  Future<QuerySnapshot> queryCollection(String collectionPath, Map<String, dynamic> filters);
  Future<void> batchWrite(List<Map<String, dynamic>> operations);
  Future<void> runTransaction(Function(Transaction) transactionHandler);
  Future<QuerySnapshot> getPaginatedCollection(String collectionPath, int limit, {DocumentSnapshot? startAfter});
  Future<QuerySnapshot> getCollectionOrdered(String collectionPath, String orderByField, {bool descending});
  Future<QuerySnapshot> getCompoundQuery(String collectionPath, Map<String, dynamic> conditions);
  Future<bool> documentExists(String collectionPath, String docId);
  Future<void> addDocumentsInBatch(String collectionPath, List<Map<String, dynamic>> documents);
  Future<int> getDocumentCount(String collectionPath);

}