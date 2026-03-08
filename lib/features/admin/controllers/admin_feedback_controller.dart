import 'package:get/get.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/services/auth_service.dart';
import '../services/admin_tour_service.dart';

class AdminFeedbackController extends GetxController {
  final _service = AdminTourService();
  final isLoading = false.obs;

  Future<void> sendFeedback({
    required String companyId,
    required String title,
    required String description,
  }) async {
    isLoading.value = true;
    try {
      final currentUser = await AuthService().getCurrentUserModel();
      final feedback = FeedbackModel(
        companyId: companyId,
        title: title,
        description: description,
        senderName: currentUser?.fullName ?? '',
        senderPhone: currentUser?.phone ?? '',
      );
      await _service.sendFeedback(feedback);
    } finally {
      isLoading.value = false;
    }
  }
}
