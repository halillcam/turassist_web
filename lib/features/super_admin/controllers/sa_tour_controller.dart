import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/tour_model.dart';
import '../services/super_admin_service.dart';

class SATourController extends GetxController {
  final _service = SuperAdminService();

  final companies = <CompanyModel>[].obs;
  final selectedCompanyId = RxnString();
  final activeTours = <TourModel>[].obs;
  final deletedTours = <TourModel>[].obs;
  final isLoading = false.obs;

  StreamSubscription? _companySub;
  StreamSubscription? _activeSub;
  StreamSubscription? _deletedSub;

  @override
  void onInit() {
    super.onInit();
    _companySub = _service.streamAllActiveCompanies().listen(
      (list) => companies.value = list,
      onError: (e) => printError(info: 'companies stream: $e'),
    );

    ever(selectedCompanyId, (_) => _reloadTours());
  }

  @override
  void onClose() {
    _companySub?.cancel();
    _activeSub?.cancel();
    _deletedSub?.cancel();
    super.onClose();
  }

  void selectCompany(String? companyId) {
    selectedCompanyId.value = companyId;
  }

  void _reloadTours() {
    _activeSub?.cancel();
    _deletedSub?.cancel();

    final id = selectedCompanyId.value;
    if (id == null) {
      activeTours.clear();
      deletedTours.clear();
      return;
    }

    _activeSub = _service
        .streamToursByCompany(id, isDeleted: false)
        .listen(
          (list) => activeTours.value = list,
          onError: (e) => printError(info: 'activeTours stream: $e'),
        );

    _deletedSub = _service
        .streamToursByCompany(id, isDeleted: true)
        .listen(
          (list) => deletedTours.value = list,
          onError: (e) => printError(info: 'deletedTours stream: $e'),
        );
  }

  SuperAdminService get service => _service;

  Future<void> deleteTour(String tourId) async {
    isLoading.value = true;
    try {
      await _service.deleteTour(tourId);
      Get.snackbar('Başarılı', 'Tur silindi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
