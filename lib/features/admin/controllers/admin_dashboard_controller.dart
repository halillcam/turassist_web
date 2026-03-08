import 'package:get/get.dart';
import '../services/admin_tour_service.dart';

class AdminDashboardController extends GetxController {
  final _service = AdminTourService();

  final selectedIndex = 0.obs;
  final companyId = RxnString();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCompanyId();
  }

  Future<void> loadCompanyId() async {
    final id = await _service.getCurrentCompanyId();
    companyId.value = id;
    isLoading.value = false;
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
