import 'package:cloud_firestore/cloud_firestore.dart';

/// Genel amaçlı Firestore yardımcı servisi.
///
/// Uygulamanin merkezi modullerinde kullanilan ortak Firestore yardimcisidir.
/// Tek seferlik okuma / yazma ve koleksiyon referansi ihtiyaclarini kapsuller.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Tekil Doküman İşlemleri ─────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> collection(String path) => _firestore.collection(path);

  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionPath).add(data);
  }

  Future<void> setDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .set(data, merge ? SetOptions(merge: true) : null);
  }

  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).get();
  }

  // ─── Koleksiyon Stream'leri ───────────────────────────────────────────────

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollectionWhere(
    String collectionPath,
    String field,
    dynamic value,
  ) {
    return _firestore.collection(collectionPath).where(field, isEqualTo: value).snapshots();
  }

  // ─── Batch İşlemleri ─────────────────────────────────────────────────────

  /// Firestore yazma batch'i döndürür.
  /// Çağıran kod batch'i doldurur ve `batch.commit()` ile gönderir.
  WriteBatch batch() => _firestore.batch();

  /// Firestore transaction çalıştırır.
  Future<T> runTransaction<T>(TransactionHandler<T> transactionHandler) {
    return _firestore.runTransaction(transactionHandler);
  }

  /// Birden fazla koleksiyon/doküman çiftini tek atomik batch'te günceller.
  /// [updates] listesindeki her öğe `{path, docId, data}` içermelidir.
  /// Firestore limiti olan 500 işlem aşılmayacak şekilde chunk'lara bölünür.
  Future<void> batchUpdate(
    List<({String collectionPath, String docId, Map<String, dynamic> data})> updates,
  ) async {
    if (updates.isEmpty) return;

    const chunkSize = 400;
    for (var i = 0; i < updates.length; i += chunkSize) {
      final b = _firestore.batch();
      for (final u in updates.skip(i).take(chunkSize)) {
        b.update(_firestore.collection(u.collectionPath).doc(u.docId), u.data);
      }
      await b.commit();
    }
  }
}
