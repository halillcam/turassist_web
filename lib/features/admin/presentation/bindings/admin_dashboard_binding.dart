import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../completion/presentation/controllers/completion_controller.dart';
import '../../../feedback/presentation/controllers/feedback_controller.dart';
import '../../../guides/presentation/bindings/guide_binding.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../participants/presentation/bindings/participant_binding.dart';
import '../../../communication/presentation/controllers/communication_controller.dart';
import '../../../tours/presentation/bindings/tour_binding.dart';
import '../../../users/presentation/bindings/user_binding.dart';

/// Admin dashboard rotasına girildiğinde kayıt edilmesi gereken tüm bağımlılıklar.
///
/// Merkezi feature controller'ları tek noktadan yönetilir;
/// eski admin-spesifik controller'lara referans yoktur.
class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Tur CRUD (merkezi — features/tours)
    TourBinding().dependencies();

    // Tur tamamlama talepleri
    Get.lazyPut(() => CompletionController(db: Get.find<FirestoreService>()), fenix: true);

    // Mesajlaşma (TourCommunicationScreen için — tourId'ye göre stream açar)
    Get.lazyPut(() => CommunicationController(db: Get.find<FirestoreService>()), fenix: true);

    // Katılımcı işlemleri
    ParticipantBinding().dependencies();

    // Rehber işlemleri
    GuideBinding().dependencies();

    // Kullanıcı işlemleri (tur detayında rehber yönetimi için gerekir)
    UserBinding().dependencies();

    // Bildirimler
    Get.lazyPut(() => NotificationController(db: Get.find<FirestoreService>()), fenix: true);

    // Geri bildirim
    Get.lazyPut(
      () => FeedbackController(db: Get.find<FirestoreService>(), auth: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
