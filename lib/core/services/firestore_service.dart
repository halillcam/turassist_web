import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Genel CRUD
  CollectionReference collection(String path) => _firestore.collection(path);

  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).add(data);
  }

  Future<void> setDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(docId).set(data);
  }

  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).get();
  }

  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  Stream<QuerySnapshot> streamCollectionWhere(String collectionPath, String field, dynamic value) {
    return _firestore.collection(collectionPath).where(field, isEqualTo: value).snapshots();
  }
}
