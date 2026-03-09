import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../controllers/company_controller.dart';

/// [CompanyController] için bağımlılık kaydı.
class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyController(db: Get.find<FirestoreService>()), fenix: true);
    // CompanyController AuthService kullanımı dolaylıdır (static method),
    // ancak AuthService'in global olarak kayıtlı olması yeterlidir.
    Get.lazyPut(() => AuthService(), fenix: true);
  }
}
