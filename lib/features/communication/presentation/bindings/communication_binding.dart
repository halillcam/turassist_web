import 'package:get/get.dart';

import '../../../../core/services/firestore_service.dart';
import '../controllers/communication_controller.dart';

/// [CommunicationController] için bağımlılık kaydı.
class CommunicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunicationController(db: Get.find<FirestoreService>()), fenix: true);
  }
}
