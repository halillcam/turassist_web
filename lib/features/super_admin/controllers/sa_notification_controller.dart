import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/notification_model.dart';
import '../services/super_admin_service.dart';

class SANotificationController extends GetxController {
  final _service = SuperAdminService();

  final companies = <CompanyModel>[].obs;
  final sentNotifications = <NotificationModel>[].obs;
  final selectedCompanyId = RxnString();
  final isLoading = false.obs;

  StreamSubscription? _companySub;
  StreamSubscription? _notifSub;

  @override
  void onInit() {
    super.onInit();
    _companySub = _service.streamAllActiveCompanies().listen(
      (list) => companies.value = list,
      onError: (e) => printError(info: 'notif companies stream: $e'),
    );
    _notifSub = _service.streamSentNotifications().listen(
      (list) => sentNotifications.value = list,
      onError: (e) => printError(info: 'sentNotifications stream: $e'),
    );
  }

  @override
  void onClose() {
    _companySub?.cancel();
    _notifSub?.cancel();
    super.onClose();
  }

  Future<void> sendNotification({required String title, required String body}) async {
    if (title.trim().isEmpty || body.trim().isEmpty) {
      Get.snackbar('Uyarı', 'Başlık ve içerik boş olamaz.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final companyId = selectedCompanyId.value;
      if (companyId != null) {
        await _service.sendNotificationToCompany(
          title: title.trim(),
          body: body.trim(),
          targetCompanyId: companyId,
        );
      } else {
        final ids = companies.map((c) => c.id!).toList();
        if (ids.isEmpty) {
          Get.snackbar('Uyarı', 'Aktif şirket bulunamadı.', snackPosition: SnackPosition.BOTTOM);
          return;
        }
        await _service.sendNotificationToAll(
          title: title.trim(),
          body: body.trim(),
          companyIds: ids,
        );
      }
      Get.snackbar('Başarılı', 'Bildirim gönderildi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
