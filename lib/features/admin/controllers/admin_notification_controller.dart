import 'package:get/get.dart';
import '../../../core/models/notification_model.dart';
import '../services/admin_tour_service.dart';

class AdminNotificationController extends GetxController {
  final _service = AdminTourService();

  Stream<List<NotificationModel>> streamNotifications(String companyId) =>
      _service.streamNotifications(companyId);

  Future<void> markNotificationAsRead(String notificationId) =>
      _service.markNotificationAsRead(notificationId);

  Future<void> markAllNotificationsAsRead(String companyId) =>
      _service.markAllNotificationsAsRead(companyId);
}
