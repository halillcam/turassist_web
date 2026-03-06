import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/notification_model.dart';

class SuperAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Yardımcı: Mevcut oturumu bozmadan yeni Auth user oluşturur ───
  Future<String> _createAuthUser(String email, String password) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final app = await Firebase.initializeApp(name: 'temp_$ts', options: Firebase.app().options);
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: app);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      await secondaryAuth.signOut();
      return uid;
    } finally {
      await app.delete();
    }
  }

  // ━━━━━━━━━━━━━ Şirketler ━━━━━━━━━━━━━

  Stream<List<CompanyModel>> streamCompanies(bool isActive) {
    return _firestore
        .collection('companies')
        .where('status', isEqualTo: isActive)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => CompanyModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<CompanyModel>> streamAllActiveCompanies() {
    return _firestore
        .collection('companies')
        .where('status', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => CompanyModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<CompanyModel?> getCompany(String companyId) async {
    final doc = await _firestore.collection('companies').doc(companyId).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return CompanyModel.fromMap(data, doc.id);
  }

  Future<void> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String city = '',
  }) async {
    final uid = await _createAuthUser(email, password);

    // Şirket dokümanı
    final company = CompanyModel(
      companyName: companyName,
      city: city,
      contactPhone: phone,
      adminUid: uid,
      status: true,
    );
    final companyDoc = await _firestore.collection('companies').add(company.toMap());

    // Admin kullanıcı dokümanı
    final user = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'admin',
      companyId: companyDoc.id,
      registeredCompanies: [companyDoc.id],
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());
  }

  Future<void> updateCompany(String companyId, Map<String, dynamic> data) {
    return _firestore.collection('companies').doc(companyId).update(data);
  }

  // ━━━━━━━━━━━━━ Kullanıcılar ━━━━━━━━━━━━━

  Stream<List<UserModel>> streamAllUsers() {
    return _firestore
        .collection('users')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList());
  }

  // ━━━━━━━━━━━━━ Turlar ━━━━━━━━━━━━━

  Stream<List<TourModel>> streamAllTours({required bool isDeleted}) {
    return _firestore
        .collection('tours')
        .where('isDeleted', isEqualTo: isDeleted)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TourModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<TourModel>> streamToursByCompany(String companyId, {required bool isDeleted}) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: isDeleted)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TourModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<String> addTour(TourModel tour) async {
    final docRef = await _firestore.collection('tours').add(tour.toMap());
    return docRef.id;
  }

  Future<void> updateTour(String tourId, Map<String, dynamic> data) {
    return _firestore.collection('tours').doc(tourId).update(data);
  }

  Future<void> deleteTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': true});
  }

  Future<TourModel?> getTour(String tourId) async {
    final doc = await _firestore.collection('tours').doc(tourId).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return TourModel.fromMap(data, doc.id);
  }

  Stream<TourModel?> streamTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return TourModel.fromMap(data, doc.id);
    });
  }

  // ━━━━━━━━━━━━━ Katılımcılar (Ticket) ━━━━━━━━━━━━━

  Stream<List<TicketModel>> streamTourTickets(String tourId) {
    return _firestore
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TicketModel.fromMap(doc.data(), doc.id)).toList());
  }

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
    final uid = await _createAuthUser(email, password);

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

  // ━━━━━━━━━━━━━ Tur Sorumlusu (Guide) ━━━━━━━━━━━━━

  Future<void> addGuideToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    final uid = await _createAuthUser(email, password);

    final user = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'guide',
      companyId: companyId,
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());

    await _firestore.collection('tours').doc(tourId).update({
      'guideId': uid,
      'guideName': fullName,
    });
  }

  // ━━━━━━━━━━━━━ Bildirimler ━━━━━━━━━━━━━

  Future<void> sendNotificationToCompany({
    required String title,
    required String body,
    required String targetCompanyId,
  }) {
    final notification = NotificationModel(
      title: title,
      body: body,
      targetCompanyId: targetCompanyId,
      senderRole: 'super_admin',
    );
    return _firestore.collection('notifications').add(notification.toMap());
  }

  Future<void> sendNotificationToAll({
    required String title,
    required String body,
    required List<String> companyIds,
  }) async {
    final batch = _firestore.batch();
    for (final companyId in companyIds) {
      final doc = _firestore.collection('notifications').doc();
      batch.set(
        doc,
        NotificationModel(
          title: title,
          body: body,
          targetCompanyId: companyId,
          senderRole: 'super_admin',
        ).toMap(),
      );
    }
    await batch.commit();
  }

  Stream<List<NotificationModel>> streamSentNotifications() {
    return _firestore
        .collection('notifications')
        .where('senderRole', isEqualTo: 'super_admin')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  // ━━━━━━━━━━━━━ Geri Bildirimler ━━━━━━━━━━━━━

  Stream<List<FeedbackModel>> streamAllFeedbacks() {
    return _firestore
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => FeedbackModel.fromMap(doc.data(), doc.id)).toList());
  }

  // ━━━━━━━━━━━━━ Şirket Admin Bilgisi Getir ━━━━━━━━━━━━━

  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return UserModel.fromMap(data, doc.id);
  }
}
