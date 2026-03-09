import 'package:get/get.dart';

import '../../../../core/services/firestore_service.dart';
import '../controllers/completion_controller.dart';

/// [CompletionController] için bağımlılık kaydı.
class CompletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompletionController(db: Get.find<FirestoreService>()), fenix: true);
  }
}
