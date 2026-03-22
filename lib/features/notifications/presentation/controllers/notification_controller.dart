import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/models/notification_model.dart';
import '../../../../core/services/firestore_service.dart';

/// Bildirim okuma/yazma işlemleri için merkezi GetX controller.
///
/// Admin modunda tek şirkete ait bildirimler okunur ve işaretlenir.
/// Super Admin modunda tüm şirketlere veya seçili şirkete bildirim gönderilir.
/// [FirestoreService] üzerinden çalışır; eski servis dosyalarına bağımlılık yoktur.
class NotificationController extends GetxController {
  final FirestoreService _db;

  NotificationController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  /// Admin tarafında izlenen bildirim listesi.
  final notifications = <NotificationModel>[].obs;

  /// SA tarafında gönderilmiş bildirim geçmişi.
  final sentNotifications = <NotificationModel>[].obs;

  final isLoading = false.obs;

  StreamSubscription? _notifSub;
  StreamSubscription? _sentSub;

  // ─── Yaşam Döngüsü ────────────────────────────────────────────────────────

  @override
  void onClose() {
    _notifSub?.cancel();
    _sentSub?.cancel();
    super.onClose();
  }

  // ─── Admin Modu ───────────────────────────────────────────────────────────

  /// Admin: belirli şirkete gelen bildirimleri gerçek zamanlı izler.
  void watchNotifications(String companyId) {
    _notifSub?.cancel();
    _notifSub = _db
        .collection('notifications')
        .where('targetCompanyId', whereIn: [companyId, ''])
        .snapshots()
        .listen((snap) {
          final items = snap.docs.map((d) => NotificationModel.fromMap(d.data(), d.id)).toList()
            ..sort((a, b) {
              final aMs = a.createdAt?.millisecondsSinceEpoch ?? 0;
              final bMs = b.createdAt?.millisecondsSinceEpoch ?? 0;
              return bMs.compareTo(aMs);
            });
          notifications.value = items;
        }, onError: _handleNotificationError);
  }

  /// Bildirimi okundu olarak işaretler.
  Future<void> markRead(String notificationId) async {
    await _db.updateDocument('notifications', notificationId, {'isRead': true});
  }

  /// Şirkete ait tüm okunmamış bildirimleri toplu okundu yapar.
  Future<void> markAllRead(String _companyId) async {
    final batch = _db.batch();
    for (final notification in notifications.where((item) => !item.isRead && item.id != null)) {
      batch.update(_db.collection('notifications').doc(notification.id), {'isRead': true});
    }
    await batch.commit();
  }

  // ─── Super Admin Modu ─────────────────────────────────────────────────────

  /// SA: gönderilmiş bildirimlerin geçmişini gerçek zamanlı izler.
  void watchSentNotifications() {
    _sentSub?.cancel();
    _sentSub = _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snap) => sentNotifications.value = snap.docs
              .map((d) => NotificationModel.fromMap(d.data(), d.id))
              .toList(),
          onError: _handleSentNotificationError,
        );
  }

  void _handleNotificationError(Object error) {
    notifications.clear();
    _handleStreamError(error);
  }

  void _handleSentNotificationError(Object error) {
    sentNotifications.clear();
    _handleStreamError(error);
  }

  void _handleStreamError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    Get.snackbar('Hata', error.toString(), snackPosition: SnackPosition.BOTTOM);
  }

  /// SA: Belirli bir şirkete veya tüm şirketlere bildirim gönderir.
  ///
  /// [targetCompanyId] null ise "broadcast" tipinde tüm şirketlere gönderilir.
  Future<void> sendNotification({
    required String title,
    required String body,
    String? targetCompanyId,
  }) async {
    isLoading.value = true;
    try {
      final data = {
        'title': title,
        'body': body,
        'senderRole': 'super_admin',
        'targetCompanyId': targetCompanyId ?? '',
        'isBroadcast': targetCompanyId == null,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _db.collection('notifications').add(data);
      Get.snackbar('Başarılı', 'Bildirim gönderildi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
