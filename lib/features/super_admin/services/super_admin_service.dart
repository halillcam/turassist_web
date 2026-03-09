import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';

/// Super admin rolünün tüm işlemlerini yöneten merkezi servis.
///
/// Kullanıcı oluşturma işlemlerinde [AuthService.createSecondaryAuthUser]
/// kullanılır; böylece mevcut super-admin oturumu hiçbir zaman kapatılmaz.
class SuperAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Yardımcı ─────────────────────────────────────────────────────────────

  Future<String> _createAuthUser(String email, String password) =>
      AuthService.createSecondaryAuthUser(email, password);

  // ━━━━━━━━━━━━━ Şirketler ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Aktif veya pasif şirketlerin gerçek zamanlı akışı.
  Stream<List<CompanyModel>> streamCompanies(bool isActive) {
    return _firestore
        .collection('companies')
        .where('status', isEqualTo: isActive)
        .snapshots()
        .map(_toCompanyList);
  }

  /// Tüm aktif şirketlerin gerçek zamanlı akışı.
  Stream<List<CompanyModel>> streamAllActiveCompanies() {
    return _firestore
        .collection('companies')
        .where('status', isEqualTo: true)
        .snapshots()
        .map(_toCompanyList);
  }

  /// Tek şirket getirir; bulunamazsa null döner.
  Future<CompanyModel?> getCompany(String companyId) async {
    final doc = await _firestore.collection('companies').doc(companyId).get();
    if (!doc.exists || doc.data() == null) return null;
    return CompanyModel.fromMap(doc.data()!, doc.id);
  }

  /// Admin UID'sine göre bağlı şirketi getirir.
  Future<CompanyModel?> getCompanyByAdminUid(String adminUid) async {
    final snap = await _firestore
        .collection('companies')
        .where('admin_uid', isEqualTo: adminUid)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return CompanyModel.fromMap(doc.data(), doc.id);
  }

  /// Yeni şirket ve ona bağlı admin kullanıcısını atomik batch ile oluşturur.
  ///
  /// İşlem sırası:
  /// 1. Firebase Auth'ta admin kullanıcısı oluşturulur (mevcut oturum korunur).
  /// 2. `companies` koleksiyonuna şirket dokümanı eklenir.
  /// 3. `users` koleksiyonuna admin kullanıcısı eklenir.
  ///
  /// Adım 2 ve 3 tek bir atomik Firestore batch'iyle yazılır.
  Future<void> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String city = '',
    String logo = '',
  }) async {
    final uid = await _createAuthUser(email, password);

    // Doküman referansını önceden üret — companyId'ye ihtiyaç var.
    final companyRef = _firestore.collection('companies').doc();
    final companyId = companyRef.id;

    final batch = _firestore.batch();

    batch.set(
      companyRef,
      CompanyModel(
        id: companyId,
        companyName: companyName,
        city: city,
        contactPhone: phone,
        logo: logo,
        adminUid: uid,
        status: true,
      ).toMap(),
    );

    batch.set(
      _firestore.collection('users').doc(uid),
      UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: 'admin',
        companyId: companyId,
        registeredCompanies: [companyId],
      ).toMap(),
    );

    await batch.commit();
  }

  /// Şirket alanlarını kısmen günceller.
  Future<void> updateCompany(String companyId, Map<String, dynamic> data) {
    return _firestore.collection('companies').doc(companyId).update(data);
  }

  /// Şirketi aktif ya da pasif yapar.
  Future<void> setCompanyStatus(String companyId, {required bool isActive}) {
    return _firestore.collection('companies').doc(companyId).update({'status': isActive});
  }

  // ━━━━━━━━━━━━━ Kullanıcılar ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Silinmemiş tüm kullanıcıların gerçek zamanlı akışı.
  Stream<List<UserModel>> streamAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snap) => _toUserList(snap)
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
        );
  }

  /// Belirli bir şirkete ait silinmemiş kullanıcıların gerçek zamanlı akışı.
  Stream<List<UserModel>> streamUsersByCompany(String companyId) {
    return _firestore
        .collection('users')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map(_toUserList);
  }

  /// UID'ye göre kullanıcı getirir; bulunamazsa null döner.
  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  /// Kullanıcıyı soft-delete ile pasife alır.
  Future<void> deactivateUser(String uid) {
    return _firestore.collection('users').doc(uid).update({'isDeleted': true});
  }

  Future<void> setUserActive(String uid, {required bool isActive}) {
    return _firestore.collection('users').doc(uid).update({'isDeleted': !isActive});
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return AuthService.sendPasswordReset(email);
  }

  /// Standalone kullanıcı oluşturur — şirket, rol ve temel bilgilerle.
  Future<void> addUser({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    String companyId = '',
    String tcNo = '',
  }) async {
    final uid = await _createAuthUser(email, password);
    await _firestore
        .collection('users')
        .doc(uid)
        .set(
          UserModel(
            uid: uid,
            fullName: fullName,
            email: email,
            phone: phone,
            role: role,
            companyId: companyId,
            tcNo: tcNo,
            registeredCompanies: companyId.isNotEmpty ? [companyId] : [],
          ).toMap(),
        );
  }

  // ━━━━━━━━━━━━━ Turlar ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Tüm şirketlerdeki aktif veya pasif turların gerçek zamanlı akışı.
  ///
  /// Birleşik index gerektiren `orderBy` kaldırıldı; sıralama client-side yapılır.
  Stream<List<TourModel>> streamAllTours({required bool isDeleted}) {
    return _firestore
        .collection('tours')
        .snapshots()
        .map(
          (snap) => _toTourList(snap).where((t) => t.isDeleted == isDeleted).toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
        );
  }

  /// Belirli bir şirketin aktif veya pasif turlarının gerçek zamanlı akışı.
  ///
  /// Birleşik index gerektiren `orderBy` + `isDeleted` filtresi kaldırıldı;
  /// yalnızca `companyId` Firestore'da filtrelenir, geri kalanı client-side işlenir.
  Stream<List<TourModel>> streamToursByCompany(String companyId, {required bool isDeleted}) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snap) => _toTourList(snap).where((t) => t.isDeleted == isDeleted).toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
        );
  }

  /// Tur ekler; dönen değer oluşturulan dokümanın ID'sidir.
  Future<String> addTour(TourModel tour) async {
    final ref = await _firestore.collection('tours').add(tour.toMap());
    return ref.id;
  }

  /// Tur günceller — yalnızca gönderilen alanlar değişir (kısmi güncelleme).
  Future<void> updateTour(String tourId, Map<String, dynamic> data) {
    return _firestore.collection('tours').doc(tourId).update(data);
  }

  /// Soft-delete: `isDeleted = true` yapılır, veri kaybolmaz.
  Future<void> deleteTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': true});
  }

  /// Turun aktif/pasif durumunu değiştirir.
  Future<void> setTourActive(String tourId, {required bool isActive}) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': !isActive});
  }

  /// Tek tur getirir; bulunamazsa null döner.
  Future<TourModel?> getTour(String tourId) async {
    final doc = await _firestore.collection('tours').doc(tourId).get();
    if (!doc.exists || doc.data() == null) return null;
    return TourModel.fromMap(doc.data()!, doc.id);
  }

  /// Tek turun gerçek zamanlı akışı.
  Stream<TourModel?> streamTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return TourModel.fromMap(doc.data()!, doc.id);
    });
  }

  // ━━━━━━━━━━━━━ Katılımcılar (Ticket) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Bir turdaki tüm biletlerin gerçek zamanlı akışı.
  Stream<List<TicketModel>> streamTourTickets(String tourId) {
    return _firestore
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TicketModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Super admin adına dışarıdan müşteri ekler.
  ///
  /// `isScanned = true` olarak ayarlanır; müşteri QR okutmadan tur detayına
  /// erişebilir. Kullanıcı ve bilet tek atomik Firestore batch'iyle yazılır.
  Future<void> addParticipantToTour({
    required String loginId,
    required String password,
    required String fullName,
    required String phone,
    required String tcNo,
    required String tourId,
    required String companyId,
    required double pricePaid,
    DateTime? departureDate,
  }) async {
    final normalizedLoginId = AuthService.normalizePanelLoginId(loginId);
    final email = AuthService.buildCustomerLoginEmail(normalizedLoginId);
    final uid = await _createAuthUser(email, password);

    final batch = _firestore.batch();

    batch.set(
      _firestore.collection('users').doc(uid),
      UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: 'customer',
        companyId: companyId,
        tcNo: tcNo,
        registeredCompanies: [companyId],
        loginId: normalizedLoginId,
        customerPassword: password,
        isPanelManagedCustomer: true,
      ).toMap(),
    );

    batch.set(
      _firestore.collection('tickets').doc(),
      TicketModel(
        tourId: tourId,
        userId: uid,
        companyId: companyId,
        passengerName: fullName,
        tcNo: tcNo,
        pricePaid: pricePaid,
        isScanned: true,
        status: 'active',
        departureDate: departureDate,
      ).toMap(),
    );

    await batch.commit();
  }

  // ━━━━━━━━━━━━━ Tur Sorumlusu (Rehber) ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Yeni rehber kullanıcısı oluşturur ve tura atar.
  ///
  /// Kullanıcı oluşturma, `users` dokümanı yazma ve tur'un `guideId/guideName`
  /// güncellenmesi tek atomik batch ile gerçekleşir.
  Future<void> addGuideToTour({
    required String guideId,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    final email = AuthService.buildGuideLoginEmail(guideId);
    final uid = await _createAuthUser(email, password);

    final batch = _firestore.batch();

    batch.set(
      _firestore.collection('users').doc(uid),
      UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: 'guide',
        companyId: companyId,
        registeredCompanies: const [],
        selectedCity: '',
        profileImage: null,
        tcNo: '',
        isDeleted: false,
        loginId: AuthService.normalizePanelLoginId(guideId),
        guidePassword: password,
      ).toMap(),
    );

    batch.update(_firestore.collection('tours').doc(tourId), {
      'guideId': uid,
      'guideName': fullName,
    });

    await batch.commit();
  }

  /// Firebase Auth ve Firestore'daki rehber parolasini günceller.
  Future<void> updateGuidePassword({
    required String guideId,
    required String guideEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondary_pwd_sa_$ts',
      options: Firebase.app().options,
    );
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final cred = await secondaryAuth.signInWithEmailAndPassword(
        email: guideEmail,
        password: currentPassword,
      );
      await cred.user!.updatePassword(newPassword);
    } finally {
      await secondaryApp.delete();
    }
    await _firestore.collection('users').doc(guideId).update({'guidePassword': newPassword});
  }

  Future<void> updateGuide(String guideId, Map<String, dynamic> data) {
    return _firestore.collection('users').doc(guideId).update(data);
  }

  Future<void> setGuideActive(String guideId, {required bool isActive}) {
    return setUserActive(guideId, isActive: isActive);
  }

  // ━━━━━━━━━━━━━ Bildirimler ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Belirli bir şirkete bildirim gönderir.
  Future<void> sendNotificationToCompany({
    required String title,
    required String body,
    required String targetCompanyId,
  }) {
    return _firestore
        .collection('notifications')
        .add(
          NotificationModel(
            title: title,
            body: body,
            targetCompanyId: targetCompanyId,
            senderRole: 'super_admin',
          ).toMap(),
        );
  }

  /// Birden fazla şirkete toplu bildirim gönderir.
  ///
  /// Firestore batch limiti (500) aşılmayacak şekilde 400'lük gruplara bölünür.
  Future<void> sendNotificationToAll({
    required String title,
    required String body,
    required List<String> companyIds,
  }) async {
    if (companyIds.isEmpty) return;

    const chunkSize = 400;
    for (var i = 0; i < companyIds.length; i += chunkSize) {
      final batch = _firestore.batch();
      for (final companyId in companyIds.skip(i).take(chunkSize)) {
        batch.set(
          _firestore.collection('notifications').doc(),
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
  }

  /// Super admin tarafından gönderilmiş tüm bildirimlerin stream'i (yeniden eskiye).
  Stream<List<NotificationModel>> streamSentNotifications() {
    return _firestore
        .collection('notifications')
        .where('senderRole', isEqualTo: 'super_admin')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toNotificationList);
  }

  /// Belirli bir şirkete gönderilmiş bildirimlerin stream'i.
  Stream<List<NotificationModel>> streamNotificationsByCompany(String companyId) {
    return _firestore
        .collection('notifications')
        .where('targetCompanyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toNotificationList);
  }

  /// Bildirimi kalıcı olarak siler.
  Future<void> deleteNotification(String notificationId) {
    return _firestore.collection('notifications').doc(notificationId).delete();
  }

  // ━━━━━━━━━━━━━ Geri Bildirimler ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Tüm şirketlerden gelen geri bildirimlerin stream'i (yeniden eskiye).
  Stream<List<FeedbackModel>> streamAllFeedbacks() {
    return _firestore
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toFeedbackList);
  }

  /// Belirli bir şirkete ait geri bildirimlerin stream'i.
  Stream<List<FeedbackModel>> streamFeedbacksByCompany(String companyId) {
    return _firestore
        .collection('feedbacks')
        .where('companyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toFeedbackList);
  }

  /// Geri bildirimi kalıcı olarak siler.
  Future<void> deleteFeedback(String feedbackId) {
    return _firestore.collection('feedbacks').doc(feedbackId).delete();
  }

  Future<void> setFeedbackResolved({
    required String feedbackId,
    required bool isResolved,
    required String resolvedBy,
  }) {
    return _firestore.collection('feedbacks').doc(feedbackId).update({
      'isResolved': isResolved,
      'resolvedBy': isResolved ? resolvedBy : FieldValue.delete(),
      'resolvedAt': isResolved ? FieldValue.serverTimestamp() : FieldValue.delete(),
    });
  }

  // ─── Dönüştürücüler ───────────────────────────────────────────────────────

  static List<CompanyModel> _toCompanyList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => CompanyModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static List<TourModel> _toTourList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => TourModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static List<UserModel> _toUserList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static List<NotificationModel> _toNotificationList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  static List<FeedbackModel> _toFeedbackList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => FeedbackModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
