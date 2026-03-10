import 'dart:async';

import 'package:get/get.dart';

import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../domain/entities/managed_user_entity.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/set_user_active_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/watch_users_usecase.dart';

/// Kullanıcı yönetimi için merkezi GetX controller.
///
/// Super Admin panelindeki [UserListScreen] ve [SAAddUserScreen] ekranları
/// bu controller'ı kullanır.
/// [FirestoreService] + [AuthService] üzerinden çalışır.
class UserController extends GetxController {
  final WatchUsersUseCase _watchUsers;
  final AddUserUseCase _addUser;
  final UpdateUserUseCase _updateUser;
  final SetUserActiveUseCase _setUserActive;
  final GetUserUseCase _getUser;

  UserController({
    required WatchUsersUseCase watchUsers,
    required AddUserUseCase addUser,
    required UpdateUserUseCase updateUser,
    required SetUserActiveUseCase setUserActive,
    required GetUserUseCase getUser,
  }) : _watchUsers = watchUsers,
       _addUser = addUser,
       _updateUser = updateUser,
       _setUserActive = setUserActive,
       _getUser = getUser;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  final allUsers = <ManagedUserEntity>[].obs;
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
  List<ManagedUserEntity> get filteredUsers {
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
    _usersSub = _watchUsers().listen(
      (result) => result.fold(
        (failure) => _handleUsersError(failure.message),
        (users) => allUsers.value = users,
      ),
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
      final result = await _addUser(
        CreateManagedUserPayload(
          email: email,
          password: password,
          fullName: fullName,
          phone: phone,
          role: role,
          companyId: companyId,
          tcNo: tcNo,
        ),
      );
      result.fold((failure) => throw StateError(failure.message), (_) {});
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
      final result = await _updateUser(uid, data);
      result.fold((failure) => throw StateError(failure.message), (_) {});
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
      final result = await _setUserActive(uid, isActive: isActive);
      result.fold((failure) => throw StateError(failure.message), (_) {});
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
  List<ManagedUserEntity> usersForCompany(String companyId) =>
      allUsers.where((u) => u.companyId == companyId).toList();

  /// UID ile tek kullanıcı getirir; bulunamazsa null döner.
  Future<ManagedUserEntity?> getUserByUid(String uid) async {
    final result = await _getUser(uid);
    return result.fold((failure) {
      Get.snackbar('Hata', failure.message, snackPosition: SnackPosition.BOTTOM);
      return null;
    }, (user) => user);
  }

  /// Kullanıcıya ait şirket adını döner — CompanyController üzerinden okur.
  String companyNameOf(String companyId) {
    final cc = Get.find<CompanyController>();
    final CompanyEntity? match = [
      ...cc.activeCompanies,
      ...cc.passiveCompanies,
    ].firstWhereOrNull((c) => c.id == companyId);
    return match?.companyName ?? '';
  }
}
