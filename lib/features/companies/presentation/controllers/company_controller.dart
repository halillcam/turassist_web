import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/models/company_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

/// Şirket CRUD operasyonları için merkezi GetX controller.
///
/// Super Admin panelindeki [CompanyListScreen], [AddCompanyScreen] ve
/// [UpdateCompanyScreen] ekranları bu controller'ı kullanır.
/// [FirestoreService] + [AuthService] üzerinden çalışır;
/// super_admin servis dosyasına bağımlılık yoktur.
class CompanyController extends GetxController {
  final FirestoreService _db;

  CompanyController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  /// Aktif (status=true) şirket listesi.
  final activeCompanies = <CompanyModel>[].obs;

  /// Pasif (status=false) şirket listesi.
  final passiveCompanies = <CompanyModel>[].obs;

  final isLoading = false.obs;

  StreamSubscription? _activeSub;
  StreamSubscription? _passiveSub;

  // ─── Stream Abonelikleri ───────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // Aktif ve pasif şirketler uygulama başladığında gerçek zamanlı izlenir
    _activeSub = _db
        .collection('companies')
        .where('status', isEqualTo: true)
        .snapshots()
        .listen(
          (snap) => activeCompanies.value = snap.docs
              .map((d) => CompanyModel.fromMap(d.data(), d.id))
              .toList(),
          onError: _handleStreamError,
        );

    _passiveSub = _db
        .collection('companies')
        .where('status', isEqualTo: false)
        .snapshots()
        .listen(
          (snap) => passiveCompanies.value = snap.docs
              .map((d) => CompanyModel.fromMap(d.data(), d.id))
              .toList(),
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
  Future<CompanyModel?> getCompany(String id) async {
    final doc = await _db.getDocument('companies', id);
    if (!doc.exists || doc.data() == null) return null;
    return CompanyModel.fromMap(doc.data()!, doc.id);
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
      // Mevcut SA oturumunu bozmadan ikincil Firebase App üzerinden admin hesabı oluşturulur
      final uid = await AuthService.createSecondaryAuthUser(email, password);

      // Şirket doküman referansı önceden üretilir — companyId'ye ihtiyaç var
      final companyRef = _db.collection('companies').doc();
      final companyId = companyRef.id;

      final batch = _db.batch();

      // Şirket dokümanı: admin_uid ve temel bilgiler
      batch.set(companyRef, {
        'companyName': companyName,
        'city': city,
        'contactPhone': phone,
        'logo': logo,
        'admin_uid': uid,
        'status': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Admin kullanıcı dokümanı: rol, companyId, iletişim bilgileri
      batch.set(
        _db.collection('users').doc(uid),
        UserModel(
          uid: uid,
          fullName: fullName,
          email: email,
          phone: phone,
          role: 'admin',
          companyId: companyId,
          registeredCompanies: [companyId],
          isDeleted: false,
        ).toMap(),
      );

      await batch.commit();

      Get.snackbar('Başarılı', 'Şirket başarıyla eklendi.', snackPosition: SnackPosition.BOTTOM);
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
      await _db.updateDocument('companies', companyId, data);
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
      await _db.updateDocument('companies', companyId, {'status': isActive});
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
