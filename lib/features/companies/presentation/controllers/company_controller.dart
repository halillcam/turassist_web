import 'dart:async';

import 'package:get/get.dart';

import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/add_company_usecase.dart';
import '../../domain/usecases/get_company_usecase.dart';
import '../../domain/usecases/set_company_status_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';
import '../../domain/usecases/watch_active_companies_usecase.dart';
import '../../domain/usecases/watch_passive_companies_usecase.dart';

/// Şirket CRUD operasyonları için merkezi GetX controller.
///
/// Super Admin panelindeki [CompanyListScreen], [AddCompanyScreen] ve
/// [UpdateCompanyScreen] ekranları bu controller'ı kullanır.
/// [FirestoreService] + [AuthService] üzerinden çalışır;
/// super_admin servis dosyasına bağımlılık yoktur.
class CompanyController extends GetxController {
  final WatchActiveCompaniesUseCase _watchActiveCompanies;
  final WatchPassiveCompaniesUseCase _watchPassiveCompanies;
  final GetCompanyUseCase _getCompany;
  final AddCompanyUseCase _addCompany;
  final UpdateCompanyUseCase _updateCompany;
  final SetCompanyStatusUseCase _setCompanyStatus;

  CompanyController({
    required WatchActiveCompaniesUseCase watchActiveCompanies,
    required WatchPassiveCompaniesUseCase watchPassiveCompanies,
    required GetCompanyUseCase getCompany,
    required AddCompanyUseCase addCompany,
    required UpdateCompanyUseCase updateCompany,
    required SetCompanyStatusUseCase setCompanyStatus,
  }) : _watchActiveCompanies = watchActiveCompanies,
       _watchPassiveCompanies = watchPassiveCompanies,
       _getCompany = getCompany,
       _addCompany = addCompany,
       _updateCompany = updateCompany,
       _setCompanyStatus = setCompanyStatus;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  /// Aktif (status=true) şirket listesi.
  final activeCompanies = <CompanyEntity>[].obs;

  /// Pasif (status=false) şirket listesi.
  final passiveCompanies = <CompanyEntity>[].obs;

  final isLoading = false.obs;

  StreamSubscription? _activeSub;
  StreamSubscription? _passiveSub;

  // ─── Stream Abonelikleri ───────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _activeSub = _watchActiveCompanies().listen(
      (result) => result.fold(
        (failure) => _handleStreamError(failure.message),
        (companies) => activeCompanies.value = companies,
      ),
      onError: _handleStreamError,
    );

    _passiveSub = _watchPassiveCompanies().listen(
      (result) => result.fold(
        (failure) => _handleStreamError(failure.message),
        (companies) => passiveCompanies.value = companies,
      ),
      onError: _handleStreamError,
    );
  }

  @override
  void onClose() {
    _activeSub?.cancel();
    _passiveSub?.cancel();
    super.onClose();
  }

  void _handleStreamError(Object error) {
    activeCompanies.clear();
    passiveCompanies.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    Get.snackbar('Hata', error.toString(), snackPosition: SnackPosition.BOTTOM);
  }

  // ─── Okuma ────────────────────────────────────────────────────────────────

  /// Tek şirketi getirir; bulunamazsa null döner.
  Future<CompanyEntity?> getCompany(String id) async {
    final result = await _getCompany(id);
    return result.fold((failure) {
      Get.snackbar('Hata', failure.message, snackPosition: SnackPosition.BOTTOM);
      return null;
    }, (company) => company);
  }

  // ─── Yazma ────────────────────────────────────────────────────────────────

  /// Yeni şirket ve bağlı admin kullanıcısını atomik Firestore batch ile oluşturur.
  ///
  /// İşlem sırası:
  /// 1. Firebase Auth'ta admin kullanıcısı oluşturulur (mevcut SA oturumu korunur).
  /// 2. Şirket ve kullanıcı dokümanları tek atomik batch'te yazılır.
  Future<void> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String city = '',
    String logo = '',
  }) async {
    isLoading.value = true;
    try {
      final result = await _addCompany(
        AddCompanyParams(
          companyName: companyName,
          fullName: fullName,
          phone: phone,
          email: email,
          password: password,
          city: city,
          logo: logo,
        ),
      );
      result.fold((failure) => throw StateError(failure.message), (_) {
        Get.snackbar('Başarılı', 'Şirket başarıyla eklendi.', snackPosition: SnackPosition.BOTTOM);
      });
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Şirket alanlarını kısmen günceller.
  Future<void> updateCompany(String companyId, Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final result = await _updateCompany(UpdateCompanyParams(companyId: companyId, data: data));
      result.fold((failure) => throw StateError(failure.message), (_) {});
      Get.snackbar('Başarılı', 'Şirket güncellendi.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Şirketi aktif veya pasife alır.
  Future<void> setCompanyStatus(String companyId, {required bool isActive}) async {
    try {
      final result = await _setCompanyStatus(
        SetCompanyStatusParams(companyId: companyId, isActive: isActive),
      );
      result.fold((failure) => throw StateError(failure.message), (_) {});
      Get.snackbar(
        'Başarılı',
        isActive ? 'Şirket aktif edildi.' : 'Şirket pasife alındı.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
