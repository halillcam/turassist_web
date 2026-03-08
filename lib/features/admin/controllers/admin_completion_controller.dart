import 'package:get/get.dart';
import '../../../core/models/tour_completion_request_model.dart';
import '../services/admin_tour_service.dart';

class AdminCompletionController extends GetxController {
  final _service = AdminTourService();

  Stream<List<TourCompletionRequestModel>> streamCompletionRequests(String companyId) =>
      _service.streamCompletionRequests(companyId);

  Future<void> approveTourCompletion({
    required String requestId,
    required String tourId,
    required String guideId,
  }) => _service.approveTourCompletion(requestId: requestId, tourId: tourId, guideId: guideId);

  Future<void> rejectTourCompletion(String requestId) => _service.rejectTourCompletion(requestId);
}
