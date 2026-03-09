import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/models/user_model.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

/// Kullanıcı yönetimi için merkezi GetX controller.
///
/// Super Admin panelindeki [UserListScreen] ve [SAAddUserScreen] ekranları
/// bu controller'ı kullanır.
/// [FirestoreService] + [AuthService] üzerinden çalışır.
class UserController extends GetxController {
  final FirestoreService _db;

  UserController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  final allUsers = <UserModel>[].obs;
  final isLoading = false.obs;

  /// Arama metni filtresi.
  final searchQuery = ''.obs;

  /// Rol filtresi; boşsa tüm roller gösterilir.
  final selectedRole = ''.obs;

  /// Aktif/pasif filtresi; null ise tüm kullanıcılar gösterilir.
  final selectedActive = Rxn<bool>();

  StreamSubscription? _usersSub;

  // ─── Computed ─────────────────────────────────────────────────────────────

  /// Aktif filtrelere göre hesaplanan kullanıcı listesi.
  List<UserModel> get filteredUsers {
    return allUsers.where((u) {
      final q = searchQuery.value.toLowerCase();
      final matchSearch =
          q.isEmpty || u.fullName.toLowerCase().contains(q) || u.email.toLowerCase().contains(q);

      final matchRole = selectedRole.value.isEmpty || u.role == selectedRole.value;

      final matchActive =
          selectedActive.value == null || (u.isDeleted == false) == selectedActive.value;

      return matchSearch && matchRole && matchActive;
    }).toList();
  }

  // ─── Yaşam Döngüsü ────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // Kullanıcı ve şirket listeleri gerçek zamanlı izlenir
    _usersSub = _db
        .collection('users')
        .snapshots()
        .listen(
          (snap) =>
              allUsers.value = snap.docs.map((d) => UserModel.fromMap(d.data(), d.id)).toList(),
          onError: _handleUsersError,
        );
  }

  @override
  void onClose() {
    _usersSub?.cancel();
    super.onClose();
  }

  void _handleUsersError(Object error) {
    allUsers.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    Get.snackbar('Hata', error.toString(), snackPosition: SnackPosition.BOTTOM);
  }

  // ─── Yazma ────────────────────────────────────────────────────────────────

  /// Yeni kullanıcı oluşturur: Firebase Auth + Firestore users dokümanı.
  Future<bool> addUser({
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
      final uid = await AuthService.createSecondaryAuthUser(email, password);
      await _db.setDocument(
        'users',
        uid,
        UserModel(
          uid: uid,
          fullName: fullName,
          email: email,
          phone: phone,
          role: role,
          companyId: companyId,
          tcNo: tcNo,
          registeredCompanies: companyId.isNotEmpty ? [companyId] : [],
          isDeleted: false,
        ).toMap(),
      );
      Get.snackbar('Başarılı', 'Kullanıcı eklendi.', snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Kullanıcı alanlarını kısmen günceller.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      await _db.updateDocument('users', uid, data);
      Get.snackbar('Başarılı', 'Kullanıcı güncellendi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Kullanıcıyı aktif veya pasife alır (soft delete flag'i).
  Future<void> toggleUserActive(String uid, {required bool isActive}) async {
    try {
      await _db.updateDocument('users', uid, {'isDeleted': !isActive});
      Get.snackbar(
        'Başarılı',
        isActive ? 'Kullanıcı aktif edildi.' : 'Kullanıcı pasife alındı.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Belirli bir şirketin kullanıcılarını döner.
  List<UserModel> usersForCompany(String companyId) =>
      allUsers.where((u) => u.companyId == companyId).toList();

  /// UID ile tek kullanıcı getirir; bulunamazsa null döner.
  Future<UserModel?> getUserByUid(String uid) async {
    final doc = await _db.getDocument('users', uid);
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  /// Kullanıcıya ait şirket adını döner — CompanyController üzerinden okur.
  String companyNameOf(String companyId) {
    final cc = Get.find<CompanyController>();
    final match = [
      ...cc.activeCompanies,
      ...cc.passiveCompanies,
    ].firstWhereOrNull((c) => c.id == companyId);
    return match?.companyName ?? '';
  }
}
