import 'package:get/get.dart';

import '../../../../core/services/firestore_service.dart';
import '../controllers/notification_controller.dart';

/// [NotificationController] için bağımlılık kaydı.
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController(db: Get.find<FirestoreService>()), fenix: true);
  }
}
