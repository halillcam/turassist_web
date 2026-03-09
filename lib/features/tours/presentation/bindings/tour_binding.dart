import 'package:get/get.dart';

import '../../data/datasources/tour_remote_data_source.dart';
import '../../data/repositories/tour_repository_impl.dart';
import '../../domain/repositories/i_tour_repository.dart';
import '../../domain/usecases/add_tour_series_usecase.dart';
import '../../domain/usecases/add_tour_usecase.dart';
import '../../domain/usecases/delete_tour_usecase.dart';
import '../../domain/usecases/get_companies_usecase.dart';
import '../../domain/usecases/get_company_name_usecase.dart';
import '../../domain/usecases/get_tour_usecase.dart';
import '../../domain/usecases/stream_active_tours_usecase.dart';
import '../../domain/usecases/stream_deleted_tours_usecase.dart';
import '../../domain/usecases/stream_tour_usecase.dart';
import '../../domain/usecases/toggle_tour_active_usecase.dart';
import '../../domain/usecases/update_tour_usecase.dart';
import '../controllers/tour_controller.dart';

class TourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITourRemoteDataSource>(() => TourRemoteDataSource(), fenix: true);

    Get.lazyPut<ITourRepository>(
      () => TourRepositoryImpl(Get.find<ITourRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => StreamActiveToursUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => StreamDeletedToursUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => StreamTourUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => GetTourUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => AddTourUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => AddTourSeriesUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => UpdateTourUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => DeleteTourUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => ToggleTourActiveUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => GetCompanyNameUseCase(Get.find<ITourRepository>()), fenix: true);
    Get.lazyPut(() => GetCompaniesUseCase(Get.find<ITourRepository>()), fenix: true);

    Get.lazyPut<TourController>(
      () => TourController(
        streamActiveTours: Get.find<StreamActiveToursUseCase>(),
        streamDeletedTours: Get.find<StreamDeletedToursUseCase>(),
        streamTour: Get.find<StreamTourUseCase>(),
        getTour: Get.find<GetTourUseCase>(),
        addTour: Get.find<AddTourUseCase>(),
        addTourSeries: Get.find<AddTourSeriesUseCase>(),
        updateTour: Get.find<UpdateTourUseCase>(),
        deleteTour: Get.find<DeleteTourUseCase>(),
        toggleTourActive: Get.find<ToggleTourActiveUseCase>(),
        getCompanyName: Get.find<GetCompanyNameUseCase>(),
        getCompanies: Get.find<GetCompaniesUseCase>(),
      ),
      fenix: true,
    );
  }
}
