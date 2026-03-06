import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/tour_completion_request_model.dart';

class AdminTourService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  // ─── Şirket ID ───
  Future<String?> getCurrentCompanyId() async {
    final uid = currentUid;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['companyId'] as String?;
  }

  // ─── Tur Stream'leri ───

  /// Aktif turlar: isDeleted == false ve companyId eşleşmesi.
  Stream<List<TourModel>> streamActiveTours(String companyId) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TourModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Pasif turlar: isDeleted == true ve companyId eşleşmesi.
  Stream<List<TourModel>> streamDeletedTours(String companyId) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TourModel.fromMap(doc.data(), doc.id)).toList());
  }

  // ─── Tur CRUD ───

  Future<String> addTour(TourModel tour) async {
    final docRef = await _firestore.collection('tours').add(tour.toMap());
    return docRef.id;
  }

  Future<void> updateTour(String tourId, Map<String, dynamic> data) {
    return _firestore.collection('tours').doc(tourId).update(data);
  }

  /// Soft-delete: isDeleted = true yapılır.
  Future<void> deleteTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': true});
  }

  Future<TourModel?> getTour(String tourId) async {
    final doc = await _firestore.collection('tours').doc(tourId).get();
    if (!doc.exists) return null;
    return TourModel.fromMap(doc.data()!, doc.id);
  }

  Stream<TourModel?> streamTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TourModel.fromMap(doc.data()!, doc.id);
    });
  }

  // ─── Katılımcılar (Ticket) ───

  Stream<List<TicketModel>> streamTourTickets(String tourId) {
    return _firestore
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TicketModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Dışarıdan müşteri ekleme: user oluştur + ticket oluştur (isScanned: true).
  Future<void> addParticipantToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tcNo,
    required String tourId,
    required String companyId,
    required double pricePaid,
    DateTime? departureDate,
  }) async {
    // Firebase Auth ile kullanıcı oluştur
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;

    // Users collection'a ekle
    final user = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'customer',
      companyId: companyId,
      tcNo: tcNo,
      registeredCompanies: [companyId],
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());

    // Tickets collection'a ekle — isScanned: true (QR gerekmez)
    final ticket = TicketModel(
      tourId: tourId,
      userId: uid,
      companyId: companyId,
      passengerName: fullName,
      tcNo: tcNo,
      pricePaid: pricePaid,
      isScanned: true,
      status: 'active',
      departureDate: departureDate,
    );
    await _firestore.collection('tickets').add(ticket.toMap());
  }

  // ─── Tur Sorumlusu (Guide) ───

  Future<void> addGuideToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;

    final user = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'guide',
      companyId: companyId,
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());

    // Tur'un guideId ve guideName alanlarını güncelle
    await _firestore.collection('tours').doc(tourId).update({
      'guideId': uid,
      'guideName': fullName,
    });
  }

  // ─── Tur Bitirme Onayı ───

  Stream<List<TourCompletionRequestModel>> streamCompletionRequests(String companyId) {
    return _firestore
        .collection('tour_completion_requests')
        .where('companyId', isEqualTo: companyId)
        .where('isApproved', isEqualTo: false)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => TourCompletionRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Onaylama: tur pasif yap, guide'ı pasif yap, isteği onayla.
  Future<void> approveTourCompletion({
    required String requestId,
    required String tourId,
    required String guideId,
  }) async {
    final batch = _firestore.batch();

    // Tur'u pasif yap
    batch.update(_firestore.collection('tours').doc(tourId), {'isDeleted': true});

    // Guide'ı pasif yap
    if (guideId.isNotEmpty) {
      batch.update(_firestore.collection('users').doc(guideId), {'isDeleted': true});
    }

    // İsteği onayla
    batch.update(_firestore.collection('tour_completion_requests').doc(requestId), {
      'isApproved': true,
    });

    await batch.commit();
  }

  Future<void> rejectTourCompletion(String requestId) {
    return _firestore.collection('tour_completion_requests').doc(requestId).delete();
  }

  // ─── Feedback ───

  Future<void> sendFeedback(FeedbackModel feedback) {
    return _firestore.collection('feedbacks').add(feedback.toMap());
  }

  // ─── Bildirimler ───

  Stream<List<NotificationModel>> streamNotifications(String companyId) {
    return _firestore
        .collection('notifications')
        .where('targetCompanyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Future<void> markNotificationAsRead(String notificationId) {
    return _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
  }
}
