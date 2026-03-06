import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/company_model.dart';
import '../services/super_admin_service.dart';

class CompanyController extends GetxController {
  final _service = SuperAdminService();

  final activeCompanies = <CompanyModel>[].obs;
  final passiveCompanies = <CompanyModel>[].obs;
  final isLoading = false.obs;

  StreamSubscription? _activeSub;
  StreamSubscription? _passiveSub;

  @override
  void onInit() {
    super.onInit();
    _activeSub = _service
        .streamCompanies(true)
        .listen(
          (list) => activeCompanies.value = list,
          onError: (e) => printError(info: 'activeCompanies stream: $e'),
        );
    _passiveSub = _service
        .streamCompanies(false)
        .listen(
          (list) => passiveCompanies.value = list,
          onError: (e) => printError(info: 'passiveCompanies stream: $e'),
        );
  }

  @override
  void onClose() {
    _activeSub?.cancel();
    _passiveSub?.cancel();
    super.onClose();
  }

  Future<CompanyModel?> getCompany(String id) => _service.getCompany(id);

  Future<void> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      await _service.addCompany(
        companyName: companyName,
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      Get.snackbar('Başarılı', 'Şirket başarıyla eklendi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCompany(String companyId, Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      await _service.updateCompany(companyId, data);
      Get.snackbar('Başarılı', 'Şirket güncellendi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
