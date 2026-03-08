import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/user_model.dart';
import '../services/super_admin_service.dart';

class SAUserController extends GetxController {
  final _service = SuperAdminService();

  final allUsers = <UserModel>[].obs;
  final companies = <CompanyModel>[].obs;
  final searchQuery = ''.obs;
  final selectedRole = RxnString();
  final selectedActive = RxnBool();
  final isLoading = false.obs;

  StreamSubscription? _usersSub;
  StreamSubscription? _companySub;

  @override
  void onInit() {
    super.onInit();
    _usersSub = _service.streamAllUsers().listen(
      (list) => allUsers.value = list,
      onError: (e) => printError(info: 'allUsers stream: $e'),
    );
    _companySub = _service.streamAllActiveCompanies().listen(
      (list) => companies.value = list,
      onError: (e) => printError(info: 'user companies stream: $e'),
    );
  }

  @override
  void onClose() {
    _usersSub?.cancel();
    _companySub?.cancel();
    super.onClose();
  }

  List<UserModel> get filteredUsers {
    var list = allUsers.toList();

    final role = selectedRole.value;
    if (role != null && role.isNotEmpty) {
      list = list.where((u) => u.role == role).toList();
    }

    final isActive = selectedActive.value;
    if (isActive != null) {
      list = list.where((u) => u.isDeleted != isActive).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((u) {
        return u.fullName.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.phone.contains(query);
      }).toList();
    }

    return list;
  }

  String getCompanyName(String companyId) {
    if (companyId.isEmpty) return '-';
    final company = companies.firstWhereOrNull((item) => item.id == companyId);
    return company?.companyName ?? companyId;
  }

  Future<void> addUser({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
    String companyId = '',
    String tcNo = '',
  }) async {
    isLoading.value = true;
    try {
      await _service.addUser(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
        companyId: companyId,
        tcNo: tcNo,
      );
      Get.snackbar(
        'Başarılı',
        'Kullanıcı başarıyla oluşturuldu.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({
    required String uid,
    required String fullName,
    required String phone,
    required String role,
    required String companyId,
    String tcNo = '',
    String selectedCity = '',
    String? profileImage,
  }) async {
    isLoading.value = true;
    try {
      await _service.updateUser(uid, {
        'fullName': fullName,
        'phone': phone,
        'role': role,
        'companyId': companyId,
        'registeredCompanies': companyId.isNotEmpty ? [companyId] : <String>[],
        'tcNo': tcNo,
        'selectedCity': selectedCity,
        'profileImage': profileImage,
      });
      Get.snackbar('Başarılı', 'Kullanıcı güncellendi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setUserActive(String uid, {required bool isActive}) async {
    isLoading.value = true;
    try {
      await _service.setUserActive(uid, isActive: isActive);
      final message = isActive ? 'Kullanıcı aktifleştirildi.' : 'Kullanıcı pasife alındı.';
      Get.snackbar('Başarılı', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
