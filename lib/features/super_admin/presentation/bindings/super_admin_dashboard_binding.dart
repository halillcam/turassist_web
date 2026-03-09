import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../../feedback/presentation/controllers/feedback_controller.dart';
import '../../../guides/presentation/controllers/guide_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../participants/presentation/controllers/participant_controller.dart';
import '../../../tours/presentation/bindings/tour_binding.dart';
import '../../../users/presentation/controllers/user_controller.dart';

/// Super Admin dashboard rotasına girildiğinde kayıt edilmesi gereken tüm bağımlılıklar.
///
/// Merkezi feature controller'ları tek noktadan yönetilir;
/// eski super_admin-spesifik controller'lara referans yoktur.
class SuperAdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Şirket yönetimi (merkezi — features/companies)
    Get.lazyPut(() => CompanyController(db: Get.find<FirestoreService>()), fenix: true);

    // Kullanıcı yönetimi (merkezi — features/users)
    Get.lazyPut(() => UserController(db: Get.find<FirestoreService>()), fenix: true);

    // Tur CRUD (merkezi — features/tours)
    TourBinding().dependencies();

    // Katılımcı işlemleri
    Get.lazyPut(() => ParticipantController(db: Get.find<FirestoreService>()), fenix: true);

    // Rehber işlemleri
    Get.lazyPut(() => GuideController(db: Get.find<FirestoreService>()), fenix: true);

    // Bildirimler
    Get.lazyPut(() => NotificationController(db: Get.find<FirestoreService>()), fenix: true);

    // Geri bildirim
    Get.lazyPut(
      () => FeedbackController(db: Get.find<FirestoreService>(), auth: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
