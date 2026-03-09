import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../completion/presentation/controllers/completion_controller.dart';
import '../../../feedback/presentation/controllers/feedback_controller.dart';
import '../../../guides/presentation/controllers/guide_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../participants/presentation/controllers/participant_controller.dart';
import '../../../communication/presentation/controllers/communication_controller.dart';
import '../../../tours/presentation/bindings/tour_binding.dart';
import '../../../users/presentation/controllers/user_controller.dart';

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
    Get.lazyPut(() => ParticipantController(db: Get.find<FirestoreService>()), fenix: true);

    // Rehber işlemleri
    Get.lazyPut(() => GuideController(db: Get.find<FirestoreService>()), fenix: true);

    // Kullanıcı işlemleri (tur detayında rehber yönetimi için gerekir)
    Get.lazyPut(() => UserController(db: Get.find<FirestoreService>()), fenix: true);

    // Bildirimler
    Get.lazyPut(() => NotificationController(db: Get.find<FirestoreService>()), fenix: true);

    // Geri bildirim
    Get.lazyPut(
      () => FeedbackController(db: Get.find<FirestoreService>(), auth: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
