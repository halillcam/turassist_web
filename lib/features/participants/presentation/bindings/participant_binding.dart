import 'package:get/get.dart';

import '../../data/datasources/participant_remote_data_source.dart';
import '../../data/repositories/participant_repository_impl.dart';
import '../../domain/repositories/i_participant_repository.dart';
import '../../domain/usecases/add_participant_usecase.dart';
import '../../domain/usecases/get_participant_user_usecase.dart';
import '../../domain/usecases/watch_tickets_usecase.dart';
import '../controllers/participant_controller.dart';

class ParticipantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IParticipantRemoteDataSource>(() => ParticipantRemoteDataSource(), fenix: true);
    Get.lazyPut<IParticipantRepository>(
      () => ParticipantRepositoryImpl(Get.find<IParticipantRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(() => WatchTicketsUseCase(Get.find<IParticipantRepository>()), fenix: true);
    Get.lazyPut(() => GetParticipantUserUseCase(Get.find<IParticipantRepository>()), fenix: true);
    Get.lazyPut(() => AddParticipantUseCase(Get.find<IParticipantRepository>()), fenix: true);
    Get.lazyPut(
      () => ParticipantController(
        watchTickets: Get.find<WatchTicketsUseCase>(),
        getParticipantUser: Get.find<GetParticipantUserUseCase>(),
        addParticipant: Get.find<AddParticipantUseCase>(),
      ),
      fenix: true,
    );
  }
}
