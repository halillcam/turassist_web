import 'package:get/get.dart';

import '../../data/datasources/company_remote_data_source.dart';
import '../../data/repositories/company_repository_impl.dart';
import '../../domain/repositories/i_company_repository.dart';
import '../../domain/usecases/add_company_usecase.dart';
import '../../domain/usecases/get_company_usecase.dart';
import '../../domain/usecases/set_company_status_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';
import '../../domain/usecases/watch_active_companies_usecase.dart';
import '../../domain/usecases/watch_passive_companies_usecase.dart';
import '../controllers/company_controller.dart';

/// [CompanyController] için bağımlılık kaydı.
class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ICompanyRemoteDataSource>(() => CompanyRemoteDataSource(), fenix: true);
    Get.lazyPut<ICompanyRepository>(
      () => CompanyRepositoryImpl(Get.find<ICompanyRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(() => WatchActiveCompaniesUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(() => WatchPassiveCompaniesUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(() => GetCompanyUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(() => AddCompanyUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(() => UpdateCompanyUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(() => SetCompanyStatusUseCase(Get.find<ICompanyRepository>()), fenix: true);
    Get.lazyPut(
      () => CompanyController(
        watchActiveCompanies: Get.find<WatchActiveCompaniesUseCase>(),
        watchPassiveCompanies: Get.find<WatchPassiveCompaniesUseCase>(),
        getCompany: Get.find<GetCompanyUseCase>(),
        addCompany: Get.find<AddCompanyUseCase>(),
        updateCompany: Get.find<UpdateCompanyUseCase>(),
        setCompanyStatus: Get.find<SetCompanyStatusUseCase>(),
      ),
      fenix: true,
    );
  }
}
