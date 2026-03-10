import 'package:get/get.dart';

import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/set_user_active_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/watch_users_usecase.dart';
import '../controllers/user_controller.dart';

/// [UserController] için bağımlılık kaydı.
class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IUserRemoteDataSource>(() => UserRemoteDataSource(), fenix: true);
    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(Get.find<IUserRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(() => WatchUsersUseCase(Get.find<IUserRepository>()), fenix: true);
    Get.lazyPut(() => AddUserUseCase(Get.find<IUserRepository>()), fenix: true);
    Get.lazyPut(() => UpdateUserUseCase(Get.find<IUserRepository>()), fenix: true);
    Get.lazyPut(() => SetUserActiveUseCase(Get.find<IUserRepository>()), fenix: true);
    Get.lazyPut(() => GetUserUseCase(Get.find<IUserRepository>()), fenix: true);
    Get.lazyPut(
      () => UserController(
        watchUsers: Get.find<WatchUsersUseCase>(),
        addUser: Get.find<AddUserUseCase>(),
        updateUser: Get.find<UpdateUserUseCase>(),
        setUserActive: Get.find<SetUserActiveUseCase>(),
        getUser: Get.find<GetUserUseCase>(),
      ),
      fenix: true,
    );
  }
}
