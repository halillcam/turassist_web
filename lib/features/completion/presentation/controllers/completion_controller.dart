import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      final tourDoc = await _db.getDocument('tours', tourId);
      final tourData = tourDoc.data();
      if (!tourDoc.exists || tourData == null) {
        throw StateError('Tur bulunamadı.');
      }

      final companyId = tourData['companyId'] as String? ?? '';
      final affectedTourIds = await _resolveAffectedTourIds(tourId, tourData);
      final panelCustomerIds = await _resolvePanelCustomerIds(affectedTourIds, companyId);
      final usersToDeactivate = <String>{};

      if (guideId.isNotEmpty && !await _guideHasOtherActiveTours(guideId, affectedTourIds)) {
        usersToDeactivate.add(guideId);
      }

      for (final userId in panelCustomerIds) {
        if (!await _panelCustomerHasOtherActiveTours(userId, affectedTourIds, companyId)) {
          usersToDeactivate.add(userId);
        }
      }

      final updates = <({String collectionPath, String docId, Map<String, dynamic> data})>[
        (
          collectionPath: 'tourCompletionRequests',
          docId: requestId,
          data: {'isApproved': true, 'approvedAt': FieldValue.serverTimestamp()},
        ),
        for (final id in affectedTourIds)
          (collectionPath: 'tours', docId: id, data: {'isDeleted': true}),
        for (final id in usersToDeactivate)
          (collectionPath: 'users', docId: id, data: {'isDeleted': true}),
      ];

      await _db.batchUpdate(updates);
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

  Future<List<String>> _resolveAffectedTourIds(String tourId, Map<String, dynamic> tourData) async {
    final seriesId = tourData['seriesId'] as String?;
    if (seriesId == null || seriesId.isEmpty) {
      return [tourId];
    }

    final snap = await _db.collection('tours').where('seriesId', isEqualTo: seriesId).get();
    if (snap.docs.isEmpty) {
      return [tourId];
    }
    return snap.docs.map((doc) => doc.id).toList();
  }

  Future<Set<String>> _resolvePanelCustomerIds(List<String> tourIds, String companyId) async {
    final userIds = <String>{};
    for (final chunk in _chunk(tourIds, 10)) {
      final ticketSnap = await _db
          .collection('tickets')
          .where('companyId', isEqualTo: companyId)
          .where('tourId', whereIn: chunk)
          .get();
      for (final doc in ticketSnap.docs) {
        final userId = doc.data()['userId'] as String?;
        if (userId == null || userId.isEmpty) continue;
        final userDoc = await _db.getDocument('users', userId);
        final userData = userDoc.data();
        if (userDoc.exists && userData?['isPanelManagedCustomer'] == true) {
          userIds.add(userId);
        }
      }
    }
    return userIds;
  }

  Future<bool> _guideHasOtherActiveTours(String guideId, List<String> affectedTourIds) async {
    final snap = await _db
        .collection('tours')
        .where('guideId', isEqualTo: guideId)
        .where('isDeleted', isEqualTo: false)
        .get();
    return snap.docs.any((doc) => !affectedTourIds.contains(doc.id));
  }

  Future<bool> _panelCustomerHasOtherActiveTours(
    String userId,
    List<String> affectedTourIds,
    String companyId,
  ) async {
    final snap = await _db
        .collection('tickets')
        .where('companyId', isEqualTo: companyId)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .get();
    if (snap.docs.isEmpty) return false;

    for (final doc in snap.docs) {
      final ticketTourId = doc.data()['tourId'] as String?;
      if (ticketTourId == null || affectedTourIds.contains(ticketTourId)) {
        continue;
      }

      final otherTour = await _db.getDocument('tours', ticketTourId);
      final otherTourData = otherTour.data();
      if (otherTour.exists && otherTourData?['isDeleted'] != true) {
        return true;
      }
    }

    return false;
  }

  List<List<String>> _chunk(List<String> values, int size) {
    final chunks = <List<String>>[];
    for (var index = 0; index < values.length; index += size) {
      chunks.add(values.skip(index).take(size).toList());
    }
    return chunks;
  }
}
