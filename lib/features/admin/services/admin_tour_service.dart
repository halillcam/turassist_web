import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/tour_completion_request_model.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';

/// Admin rolündeki şirket yöneticilerinin kullandığı tur servisi.
///
/// Kullanıcı oluşturma işlemlerinde [AuthService.createSecondaryAuthUser]
/// kullanılır; böylece katılımcı veya rehber eklenirken mevcut admin oturumu
/// hiçbir zaman kapatılmaz.
class AdminTourService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUid => _auth.currentUser?.uid;

  // ─── Şirket ID ──────────────────────────────────────────────────────────

  /// Oturumda bulunan admin kullanıcısının `companyId` değerini getirir.
  Future<String?> getCurrentCompanyId() async {
    final uid = _currentUid;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['companyId'] as String?;
  }

  // ─── Turlar ─────────────────────────────────────────────────────────────

  /// Aktif (silinmemiş) turların gerçek zamanlı akışı.
  Stream<List<TourModel>> streamActiveTours(String companyId) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toTourList);
  }

  /// Pasif (silinmiş) turların gerçek zamanlı akışı.
  Stream<List<TourModel>> streamDeletedTours(String companyId) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_toTourList);
  }

  /// Yeni tur ekler; dönen değer oluşturulan dokümanın ID'sidir.
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

  // ─── Katılımcılar (Ticket) ───────────────────────────────────────────────

  /// Bir turdaki tüm biletlerin gerçek zamanlı akışı.
  Stream<List<TicketModel>> streamTourTickets(String tourId) {
    return _firestore
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TicketModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Dışarıdan müşteri ekler: yeni Firebase Auth kullanıcısı + `users` dokümanı
  /// + `tickets` dokümanı tek atomik Firestore batch'iyle oluşturulur.
  ///
  /// `isScanned = true` olduğundan müşteri QR okutmadan tur detayına erişebilir.
  /// Herhangi bir adım başarısız olursa tüm işlem geri alınır.
  ///
  /// Mevcut admin oturumu korunur — [AuthService.createSecondaryAuthUser].
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
    final uid = await AuthService.createSecondaryAuthUser(email, password);

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

  // ─── Tur Sorumlusu (Rehber) ─────────────────────────────────────────────

  /// Yeni rehber kullanıcısı oluşturur ve tur'un `guideId` / `guideName`
  /// alanlarını günceller. Tüm yazma işlemleri tek atomik batch ile yapılır.
  ///
  /// Mevcut admin oturumu korunur — [AuthService.createSecondaryAuthUser].
  Future<void> addGuideToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    final uid = await AuthService.createSecondaryAuthUser(email, password);

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
      ).toMap(),
    );

    batch.update(_firestore.collection('tours').doc(tourId), {
      'guideId': uid,
      'guideName': fullName,
    });

    await batch.commit();
  }

  /// Mevcut rehberi pasife alır ve tur'daki bağlantısını temizler.
  Future<void> removeGuideFromTour({required String tourId, required String guideId}) async {
    final batch = _firestore.batch();

    if (guideId.isNotEmpty) {
      batch.update(_firestore.collection('users').doc(guideId), {'isDeleted': true});
    }

    batch.update(_firestore.collection('tours').doc(tourId), {'guideId': '', 'guideName': ''});

    await batch.commit();
  }

  // ─── Tur Bitirme Onayı ───────────────────────────────────────────────────

  /// Bu şirkete ait, henüz onaylanmamış tur bitirme isteklerinin gerçek zamanlı akışı.
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

  /// Tur bitişini onaylar.
  ///
  /// Tek atomik batch işlemi ile:
  /// - Tur `isDeleted = true` yapılır,
  /// - Rehber kullanıcısı `isDeleted = true` yapılır,
  /// - İstek `isApproved = true` olarak işaretlenir.
  Future<void> approveTourCompletion({
    required String requestId,
    required String tourId,
    required String guideId,
  }) async {
    final batch = _firestore.batch();

    batch.update(_firestore.collection('tours').doc(tourId), {'isDeleted': true});

    if (guideId.isNotEmpty) {
      batch.update(_firestore.collection('users').doc(guideId), {'isDeleted': true});
    }

    batch.update(_firestore.collection('tour_completion_requests').doc(requestId), {
      'isApproved': true,
    });

    await batch.commit();
  }

  /// İsteği reddeder ve dokümanı siler.
  Future<void> rejectTourCompletion(String requestId) {
    return _firestore.collection('tour_completion_requests').doc(requestId).delete();
  }

  // ─── Geri Bildirim ──────────────────────────────────────────────────────

  /// Super admin'e geri bildirim gönderir.
  Future<void> sendFeedback(FeedbackModel feedback) {
    return _firestore.collection('feedbacks').add(feedback.toMap());
  }

  // ─── Bildirimler ────────────────────────────────────────────────────────

  /// Bu şirkete gönderilmiş tüm bildirimlerin gerçek zamanlı akışı (yeniden eskiye).
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

  /// Okunmamış bildirim sayısının gerçek zamanlı akışı.
  Stream<int> streamUnreadNotificationCount(String companyId) {
    return _firestore
        .collection('notifications')
        .where('targetCompanyId', isEqualTo: companyId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.size);
  }

  /// Bildirimi okundu olarak işaretler.
  Future<void> markNotificationAsRead(String notificationId) {
    return _firestore.collection('notifications').doc(notificationId).update({'isRead': true});
  }

  /// Bu şirkete ait tüm okunmamış bildirimleri okundu olarak işaretler.
  ///
  /// Firestore batch limiti (500) aşılmayacak şekilde 400'lük gruplara bölünür.
  Future<void> markAllNotificationsAsRead(String companyId) async {
    final snap = await _firestore
        .collection('notifications')
        .where('targetCompanyId', isEqualTo: companyId)
        .where('isRead', isEqualTo: false)
        .get();

    if (snap.docs.isEmpty) return;

    const chunkSize = 400;
    for (var i = 0; i < snap.docs.length; i += chunkSize) {
      final batch = _firestore.batch();
      for (final doc in snap.docs.skip(i).take(chunkSize)) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    }
  }

  // ─── Yardımcılar ────────────────────────────────────────────────────────

  static List<TourModel> _toTourList(QuerySnapshot snap) {
    return snap.docs
        .map((doc) => TourModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
