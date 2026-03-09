import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/models/tour_communication_item.dart';
import '../../../../core/services/firestore_service.dart';

/// Tur içi iletişim (mesaj & duyuru) yönetimi için merkezi GetX controller.
///
/// Admin paneli [TourCommunicationScreen] ekranı bu controller'ı kullanır.
/// [FirestoreService] üzerinden `tours/{tourId}/messages` ve
/// `tours/{tourId}/announcements` alt-koleksiyonlarına erişir.
/// Herhangi bir admin/super_admin servis dosyasına bağımlılık yoktur.
class CommunicationController extends GetxController {
  final FirestoreService _db;

  CommunicationController({required FirestoreService db}) : _db = db;

  // ─── Mesaj Akışı ──────────────────────────────────────────────────────────

  /// Verilen [tourId]'ye ait tur mesajlarının reaktif akışını döndürür.
  /// Widget katmanı bu stream'i doğrudan `StreamBuilder` ile tüketir.
  Stream<List<TourCommunicationItem>> streamMessages(String tourId) {
    return _streamSubcollection(tourId, 'messages');
  }

  /// Verilen [tourId]'ye ait tur duyurularının reaktif akışını döndürür.
  Stream<List<TourCommunicationItem>> streamAnnouncements(String tourId) {
    return _streamSubcollection(tourId, 'announcements');
  }

  // ─── Özel Yardımcı ────────────────────────────────────────────────────────

  /// Alt-koleksiyonu tarihe göre azalan sıralamayla akış olarak döndürür.
  Stream<List<TourCommunicationItem>> _streamSubcollection(String tourId, String subcollection) {
    return _db
        .collection('tours')
        .doc(tourId)
        .collection(subcollection)
        .snapshots()
        .handleError((error) {
          final message = error.toString().toLowerCase();
          if (message.contains('permission-denied') ||
              message.contains('insufficient permissions')) {
            return;
          }
          throw error;
        })
        .map((snap) {
          final items = snap.docs
              .map((d) => TourCommunicationItem.fromMap(d.data(), d.id))
              .toList();
          // En yeni mesaj/duyuru en üstte görünmesi için tarihe göre sırala
          items.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          return items;
        });
  }
}
