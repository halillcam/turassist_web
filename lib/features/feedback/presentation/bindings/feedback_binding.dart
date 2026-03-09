import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../controllers/feedback_controller.dart';

/// [FeedbackController] için bağımlılık kaydı.
class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FeedbackController(db: Get.find<FirestoreService>(), auth: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
