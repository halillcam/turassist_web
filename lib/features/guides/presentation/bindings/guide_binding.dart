import 'package:get/get.dart';

import '../../data/datasources/guide_remote_data_source.dart';
import '../../data/repositories/guide_repository_impl.dart';
import '../../domain/repositories/i_guide_repository.dart';
import '../../domain/usecases/add_guide_usecase.dart';
import '../controllers/guide_controller.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IGuideRemoteDataSource>(() => GuideRemoteDataSource(), fenix: true);
    Get.lazyPut<IGuideRepository>(
      () => GuideRepositoryImpl(Get.find<IGuideRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(() => AddGuideUseCase(Get.find<IGuideRepository>()), fenix: true);
    Get.lazyPut(
      () => GuideController(addGuide: Get.find<AddGuideUseCase>()),
      fenix: true,
    );
  }
}