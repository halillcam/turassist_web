import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../controllers/user_controller.dart';

/// [UserController] için bağımlılık kaydı.
class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(db: Get.find<FirestoreService>()), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
  }
}
