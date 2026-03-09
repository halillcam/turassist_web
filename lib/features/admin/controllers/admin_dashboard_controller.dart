import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/services/firestore_service.dart';

/// Admin panelinin navigasyon durumunu ve şirket kimliğini yöneten controller.
///
/// Şirket kimliği, AdminTourService yerine doğrudan [FirestoreService] ile
/// `users/{uid}.companyId` alanından okunur.
class AdminDashboardController extends GetxController {
  final FirestoreService _db;

  AdminDashboardController({required FirestoreService db}) : _db = db;

  final selectedIndex = 0.obs;
  final companyId = RxnString();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    final doc = await _db.getDocument('users', uid);
    if (doc.exists && doc.data() != null) {
      companyId.value = doc.data()!['companyId'] as String?;
    }
    isLoading.value = false;
  }

  void setSelectedIndex(int index) => selectedIndex.value = index;
}
