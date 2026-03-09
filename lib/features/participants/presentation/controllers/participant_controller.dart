import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/models/ticket_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

/// Katılımcı (bilet) ekleme ve listeleme için merkezi GetX controller.
///
/// [AddParticipantScreen] ve [ParticipantsListScreen] (hem admin hem SA) bu
/// controller'ı kullanır. [FirestoreService] + [AuthService] core servisleri
/// üzerinden çalışır; admin/super_admin servis dosyalarına bağımlılık yoktur.
class ParticipantController extends GetxController {
  final FirestoreService _db;

  ParticipantController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  /// Seçili tura ait bilet listesi (ParticipantsListScreen tarafından gözlenir).
  final tickets = <TicketModel>[].obs;
  final isLoading = false.obs;

  StreamSubscription? _ticketsSub;

  // ─── Bilet Akışı ──────────────────────────────────────────────────────────

  /// [tourId] için bilet akışını başlatır. Önceki abonelik iptal edilir.
  void watchTickets(String tourId) {
    _ticketsSub?.cancel();
    _ticketsSub = _db.collection('tickets').where('tourId', isEqualTo: tourId).snapshots().listen((
      snap,
    ) {
      tickets.value = snap.docs.map((d) => TicketModel.fromMap(d.data(), d.id)).toList();
    }, onError: _handleTicketsError);
  }

  /// Aboneliği durdurur ve listeyi temizler. Ekran dispose olduğunda çağrılır.
  void stopWatching() {
    _ticketsSub?.cancel();
    tickets.clear();
  }

  @override
  void onClose() {
    _ticketsSub?.cancel();
    super.onClose();
  }

  void _handleTicketsError(Object error) {
    tickets.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    _showError(error.toString());
  }

  // ─── Katılımcı Ekle ────────────────────────────────────────────────────────

  /// Panelden fiziksel bilet oluşturur:
  /// 1. Firebase Auth'ta müşteri hesabı açılır (mevcut oturum bozulmaz).
  /// 2. `users` koleksiyonuna hesap dokümanı yazılır.
  /// 3. `tickets` koleksiyonuna bilet dokümanı eklenir.
  Future<bool> addParticipant({
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
    isLoading.value = true;
    try {
      final normalized = AuthService.normalizePanelLoginId(loginId);
      final email = AuthService.buildCustomerLoginEmail(normalized);

      // Mevcut admin/SA oturumunu bozmadan ikincil Firebase App üzerinden
      // yeni müşteri hesabı oluşturulur
      final uid = await AuthService.createSecondaryAuthUser(email, password);

      final user = UserModel(
        uid: uid,
        loginId: normalized,
        email: email,
        fullName: fullName,
        phone: phone,
        tcNo: tcNo,
        role: 'customer',
        companyId: companyId,
        isPanelManagedCustomer: true,
        customerPassword: password,
        isDeleted: false,
      );

      await _db.setDocument('users', uid, user.toMap());

      final ticket = TicketModel(
        tourId: tourId,
        userId: uid,
        companyId: companyId,
        passengerName: fullName,
        tcNo: tcNo,
        pricePaid: pricePaid,
        departureDate: departureDate,
      );

      await _db.addDocument('tickets', ticket.toMap());

      _showSuccess('Katılımcı başarıyla eklendi.');
      return true;
    } catch (e) {
      _showError(_friendlyError(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Bilet Kullanıcısını Getir ─────────────────────────────────────────────

  /// Bilet sahibinin [UserModel]'ini getirir; bulunamazsa null döner.
  Future<UserModel?> getTicketUser(String userId) async {
    final doc = await _db.getDocument('users', userId);
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  // ─── Yardımcılar ───────────────────────────────────────────────────────────

  String _friendlyError(Object error) {
    final msg = error.toString();
    if (msg.contains('email-already-in-use')) {
      return 'Bu Müşteri ID zaten kullanılıyor.';
    }
    if (msg.contains('weak-password')) return 'Şifre en az 6 karakter olmalıdır.';
    return 'İşlem başarısız: $msg';
  }

  void _showSuccess(String msg) =>
      Get.snackbar('Başarılı', msg, snackPosition: SnackPosition.BOTTOM);

  void _showError(String msg) => Get.snackbar('Hata', msg, snackPosition: SnackPosition.BOTTOM);
}
