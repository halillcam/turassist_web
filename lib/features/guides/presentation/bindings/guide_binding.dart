import 'package:get/get.dart';

import '../../../../core/services/firestore_service.dart';
import '../controllers/guide_controller.dart';

/// [GuideController] için bağımlılık kaydı.
class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GuideController(db: Get.find<FirestoreService>()), fenix: true);
  }
}
