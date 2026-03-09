import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/models/tour_completion_request_model.dart';
import '../../../../core/services/firestore_service.dart';

/// Tur tamamlama onay sürecini yöneten merkezi GetX controller.
///
/// Admin paneli [TourCompletionApprovalScreen] ekranı bu controller'ı kullanır.
/// [FirestoreService] üzerinden `tourCompletionRequests` koleksiyonuna erişir.
/// Herhangi bir admin/super_admin servis dosyasına bağımlılık yoktur.
class CompletionController extends GetxController {
  final FirestoreService _db;

  CompletionController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  /// Şirkete ait tamamlanmamış tur onay talepleri.
  final requests = <TourCompletionRequestModel>[].obs;
  final isLoading = false.obs;

  StreamSubscription? _requestsSub;

  // ─── Akış Yönetimi ─────────────────────────────────────────────────────────

  /// Verilen [companyId] için tamamlanmamış onay taleplerini gerçek zamanlı
  /// olarak dinlemeye başlar. Önceki abonelik varsa iptal edilir.
  void watchRequests(String companyId) {
    _requestsSub?.cancel();
    _requestsSub = _db
        .collection('tourCompletionRequests')
        .where('companyId', isEqualTo: companyId)
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .listen((snap) {
          requests.value = snap.docs
              .map((d) => TourCompletionRequestModel.fromMap(d.data(), d.id))
              .toList();
        }, onError: _handleRequestsError);
  }

  @override
  void onClose() {
    _requestsSub?.cancel();
    super.onClose();
  }

  void _handleRequestsError(Object error) {
    requests.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    _showError(error.toString());
  }

  // ─── Onaylama / Reddetme ───────────────────────────────────────────────────

  /// Tamamlama talebini onaylar: talebi siler, tur `isDeleted = true` yapar,
  /// rehber hesabını devre dışı bırakır.
  Future<void> approve({
    required String requestId,
    required String tourId,
    required String guideId,
  }) async {
    isLoading.value = true;
    try {
      // Talep silinir (ya da onaylı olarak işaretlenir)
      await _db.updateDocument('tourCompletionRequests', requestId, {'isApproved': true});
      // Tur pasife alınır (soft-delete)
      await _db.updateDocument('tours', tourId, {'isDeleted': true});
      // Rehber hesabı devre dışı bırakılır
      await _db.updateDocument('users', guideId, {'isDeleted': true});
      _showSuccess('Tur tamamlama onaylandı.');
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Tamamlama talebini reddeder: talebi Firestore'dan siler.
  Future<void> reject(String requestId) async {
    isLoading.value = true;
    try {
      await _db.deleteDocument('tourCompletionRequests', requestId);
      _showSuccess('Talep reddedildi.');
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Yardımcılar ───────────────────────────────────────────────────────────

  void _showSuccess(String msg) =>
      Get.snackbar('Başarılı', msg, snackPosition: SnackPosition.BOTTOM);

  void _showError(String msg) => Get.snackbar('Hata', msg, snackPosition: SnackPosition.BOTTOM);
}
