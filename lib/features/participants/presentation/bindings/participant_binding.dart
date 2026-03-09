import 'package:get/get.dart';

import '../../../../core/services/firestore_service.dart';
import '../controllers/participant_controller.dart';

/// [ParticipantController] için bağımlılık kaydı.
class ParticipantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParticipantController(db: Get.find<FirestoreService>()), fenix: true);
  }
}
