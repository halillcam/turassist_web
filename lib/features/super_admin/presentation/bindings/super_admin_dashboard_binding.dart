import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../companies/presentation/bindings/company_binding.dart';
import '../../../feedback/presentation/controllers/feedback_controller.dart';
import '../../../guides/presentation/bindings/guide_binding.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../participants/presentation/bindings/participant_binding.dart';
import '../../../tours/presentation/bindings/tour_binding.dart';
import '../../../users/presentation/bindings/user_binding.dart';

/// Super Admin dashboard rotasına girildiğinde kayıt edilmesi gereken tüm bağımlılıklar.
///
/// Merkezi feature controller'ları tek noktadan yönetilir;
/// eski super_admin-spesifik controller'lara referans yoktur.
class SuperAdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Şirket yönetimi (merkezi — features/companies)
    CompanyBinding().dependencies();

    // Kullanıcı yönetimi (merkezi — features/users)
    UserBinding().dependencies();

    // Tur CRUD (merkezi — features/tours)
    TourBinding().dependencies();

    // Katılımcı işlemleri
    ParticipantBinding().dependencies();

    // Rehber işlemleri
    GuideBinding().dependencies();

    // Bildirimler
    Get.lazyPut(() => NotificationController(db: Get.find<FirestoreService>()), fenix: true);

    // Geri bildirim
    Get.lazyPut(
      () => FeedbackController(db: Get.find<FirestoreService>(), auth: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
