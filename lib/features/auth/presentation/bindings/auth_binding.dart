import 'package:get/get.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../controllers/auth_controller.dart';

/// Auth modülünün bağımlılık grafiğini oluşturur.
///
/// Çağrı sırası (bağımlılık zincirine göre):
///   DataSource → Repository → UseCases → Controller
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<IAuthRemoteDataSource>()) {
      Get.lazyPut<IAuthRemoteDataSource>(() => AuthRemoteDataSource(), fenix: true);
    }

    if (!Get.isRegistered<IAuthRepository>()) {
      Get.lazyPut<IAuthRepository>(
        () => AuthRepositoryImpl(Get.find<IAuthRemoteDataSource>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<SignInUseCase>()) {
      Get.lazyPut(() => SignInUseCase(Get.find<IAuthRepository>()), fenix: true);
    }

    if (!Get.isRegistered<SignOutUseCase>()) {
      Get.lazyPut(() => SignOutUseCase(Get.find<IAuthRepository>()), fenix: true);
    }

    if (!Get.isRegistered<GetCurrentUserUseCase>()) {
      Get.lazyPut(() => GetCurrentUserUseCase(Get.find<IAuthRepository>()), fenix: true);
    }

    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(
          signIn: Get.find<SignInUseCase>(),
          signOut: Get.find<SignOutUseCase>(),
          getCurrentUser: Get.find<GetCurrentUserUseCase>(),
        ),
        fenix: true,
      );
    }
  }
}
