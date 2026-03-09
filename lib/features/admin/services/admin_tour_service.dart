import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/tour_communication_item.dart';
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

  // İleride ürün kararı değişirse bu değer 8 veya 10 yapılarak daha fazla hafta üretilebilir.
  static const int _defaultRecurringWeekCount = 4;

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
        .snapshots()
        .map(
          (snap) => _toTourList(snap).where((tour) => !tour.isDeleted).toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
        );
  }

  /// Pasif (silinmiş) turların gerçek zamanlı akışı.
  Stream<List<TourModel>> streamDeletedTours(String companyId) {
    return _firestore
        .collection('tours')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snap) => _toTourList(snap).where((tour) => tour.isDeleted).toList()
            ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
        );
  }

  /// Yeni tur ekler; dönen değer oluşturulan dokümanın ID'sidir.
  Future<String> addTour(TourModel tour) async {
    final ref = await _firestore.collection('tours').add(tour.toMap());
    return ref.id;
  }

  Future<List<String>> addTourSeries(TourModel templateTour) async {
    final departureDates = _resolveDepartureDates(
      weeklyDays: templateTour.departureDays,
      explicitDates: templateTour.departureDates,
    );

    if (departureDates.isEmpty) {
      throw Exception('Tur için oluşturulacak bir çıkış tarihi bulunamadı.');
    }

    final seriesId = templateTour.seriesId ?? 'series_${DateTime.now().microsecondsSinceEpoch}';
    final createdIds = <String>[];

    for (final departureDate in departureDates) {
      final tour = TourModel(
        title: templateTour.title,
        description: templateTour.description,
        extraDetail: templateTour.extraDetail,
        price: templateTour.price,
        imageUrl: templateTour.imageUrl,
        companyId: templateTour.companyId,
        companyName: templateTour.companyName,
        guideId: templateTour.guideId,
        guideName: templateTour.guideName,
        capacity: templateTour.capacity,
        city: templateTour.city,
        region: templateTour.region,
        busInfo: templateTour.busInfo,
        program: templateTour.program,
        createdAt: templateTour.createdAt,
        isDeleted: templateTour.isDeleted,
        departureDays: List<int>.from(templateTour.departureDays),
        departureTime: templateTour.departureTime,
        departureDate: departureDate,
        departureDates: null,
        seriesId: seriesId,
      );
      createdIds.add(await addTour(tour));
    }

    return createdIds;
  }

  /// Tur günceller — yalnızca gönderilen alanlar değişir (kısmi güncelleme).
  Future<void> updateTour(String tourId, Map<String, dynamic> data) {
    return _firestore.collection('tours').doc(tourId).update(data);
  }

  /// Soft-delete: `isDeleted = true` yapılır, veri kaybolmaz.
  Future<void> deleteTour(String tourId) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': true});
  }

  Future<void> setTourActive(String tourId, {required bool isActive}) {
    return _firestore.collection('tours').doc(tourId).update({'isDeleted': !isActive});
  }

  /// Şirket adını getirir; bulunamazsa boş string döner.
  Future<String> getCompanyName(String companyId) async {
    final doc = await _firestore.collection('companies').doc(companyId).get();
    return doc.data()?['companyName'] as String? ?? '';
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

  Stream<List<TourCommunicationItem>> streamTourMessages(String tourId) {
    return _streamTourSubcollection(tourId, 'messages');
  }

  Stream<List<TourCommunicationItem>> streamTourAnnouncements(String tourId) {
    return _streamTourSubcollection(tourId, 'announcements');
  }

  Stream<List<TourCommunicationItem>> _streamTourSubcollection(
    String tourId,
    String subcollection,
  ) {
    return _firestore.collection('tours').doc(tourId).collection(subcollection).snapshots().map((
      snap,
    ) {
      final items = snap.docs
          .map((doc) => TourCommunicationItem.fromMap(doc.data(), doc.id))
          .toList();
      items.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      return items;
    });
  }

  List<DateTime> _resolveDepartureDates({
    required List<int> weeklyDays,
    required List<DateTime>? explicitDates,
  }) {
    if (explicitDates != null && explicitDates.isNotEmpty) {
      final dates = explicitDates.map(_normalizeDate).toSet().toList()..sort();
      return dates;
    }

    final dates = <DateTime>{};
    final today = _normalizeDate(DateTime.now());

    for (final weekday in weeklyDays.toSet()) {
      final offset = (weekday - today.weekday + 7) % 7;
      final firstDate = today.add(Duration(days: offset));
      for (var i = 0; i < _defaultRecurringWeekCount; i++) {
        dates.add(firstDate.add(Duration(days: 7 * i)));
      }
    }

    final result = dates.toList()..sort();
    return result;
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

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

  Future<List<String>> _getPanelManagedParticipantIdsForTour(String tourId) async {
    final ticketSnap = await _firestore
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .get();
    final userIds = ticketSnap.docs
        .map((doc) => (doc.data()['userId'] as String?)?.trim() ?? '')
        .where((userId) => userId.isNotEmpty)
        .toSet()
        .toList();

    if (userIds.isEmpty) {
      return const [];
    }

    final docs = await Future.wait(
      userIds.map((userId) => _firestore.collection('users').doc(userId).get()),
    );

    return docs
        .where((doc) => doc.exists && (doc.data()?['isPanelManagedCustomer'] == true))
        .map((doc) => doc.id)
        .toList();
  }

  // ─── Tur Sorumlusu (Rehber) ─────────────────────────────────────────────

  /// Yeni rehber kullanıcısı oluşturur ve tur'un `guideId` / `guideName`
  /// alanlarını günceller. Tüm yazma işlemleri tek atomik batch ile yapılır.
  ///
  /// Mevcut admin oturumu korunur — [AuthService.createSecondaryAuthUser].
  Future<void> addGuideToTour({
    required String guideId,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    final email = AuthService.buildGuideLoginEmail(guideId);
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
  /// İkincil uygulama üzerinden mevcut parola ile giriş yapılır, yeni parola set edilir.
  Future<void> updateGuidePassword({
    required String guideId,
    required String guideEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondary_pwd_$ts',
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

  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateGuide(String guideId, Map<String, dynamic> data) {
    return _firestore.collection('users').doc(guideId).update(data);
  }

  Future<void> setGuideActive(String guideId, {required bool isActive}) {
    return _firestore.collection('users').doc(guideId).update({'isDeleted': !isActive});
  }

  Future<void> sendPasswordResetEmail(String email) {
    return AuthService.sendPasswordReset(email);
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
        .snapshots()
        .map((snap) {
          final requests = snap.docs
              .map((doc) => TourCompletionRequestModel.fromMap(doc.data(), doc.id))
              .where((request) => !request.isApproved)
              .toList();
          requests.sort(
            (a, b) => (b.requestedAt?.toDate() ?? DateTime(0)).compareTo(
              a.requestedAt?.toDate() ?? DateTime(0),
            ),
          );
          return requests;
        });
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
    final panelManagedParticipantIds = await _getPanelManagedParticipantIdsForTour(tourId);
    final batch = _firestore.batch();

    batch.update(_firestore.collection('tours').doc(tourId), {'isDeleted': true});

    if (guideId.isNotEmpty) {
      batch.update(_firestore.collection('users').doc(guideId), {'isDeleted': true});
    }

    for (final participantId in panelManagedParticipantIds) {
      batch.update(_firestore.collection('users').doc(participantId), {'isDeleted': true});
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
        .snapshots()
        .map((snap) {
          final notifications = snap.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList();
          notifications.sort(
            (a, b) => (b.createdAt?.toDate() ?? DateTime(0)).compareTo(
              a.createdAt?.toDate() ?? DateTime(0),
            ),
          );
          return notifications;
        });
  }

  /// Okunmamış bildirim sayısının gerçek zamanlı akışı.
  Stream<int> streamUnreadNotificationCount(String companyId) {
    return _firestore
        .collection('notifications')
        .where('targetCompanyId', isEqualTo: companyId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .where((notification) => !notification.isRead)
              .length,
        );
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
        .get();

    final unreadDocs = snap.docs.where((doc) => doc.data()['isRead'] != true).toList();

    if (unreadDocs.isEmpty) return;

    const chunkSize = 400;
    for (var i = 0; i < unreadDocs.length; i += chunkSize) {
      final batch = _firestore.batch();
      for (final doc in unreadDocs.skip(i).take(chunkSize)) {
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
