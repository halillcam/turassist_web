import 'package:get/get.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Uygulama ayaga kalkarken kayit edilmesi gereken tum bagimliliklar.
///
/// [AuthBinding]'den fark: bu binding uygulama boyunca yasayan (permanent: true)
/// servisleri kayit eder.
/// [FirestoreService] ve [AuthService] tum merkezi feature controller'larinin
/// ortak altyapisi oldugu icin burada global olarak kayit edilir.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // --- Altyapi Servisleri ---
    // Tum merkezi feature controller'lari bu servisleri Get.find ile bulur.
    Get.put<FirestoreService>(FirestoreService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);

    // --- Auth Katmani ---
    Get.put<IAuthRemoteDataSource>(AuthRemoteDataSource(), permanent: true);

    Get.put<IAuthRepository>(
      AuthRepositoryImpl(Get.find<IAuthRemoteDataSource>()),
      permanent: true,
    );

    Get.put(SignInUseCase(Get.find<IAuthRepository>()), permanent: true);
    Get.put(SignOutUseCase(Get.find<IAuthRepository>()), permanent: true);
    Get.put(GetCurrentUserUseCase(Get.find<IAuthRepository>()), permanent: true);
    Get.put<AuthController>(
      AuthController(
        signIn: Get.find<SignInUseCase>(),
        signOut: Get.find<SignOutUseCase>(),
        getCurrentUser: Get.find<GetCurrentUserUseCase>(),
      ),
      permanent: true,
    );
  }
}