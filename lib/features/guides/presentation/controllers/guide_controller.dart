import 'package:get/get.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';

/// Rehber (tur sorumlusu) ekleme ve yönetimi için merkezi GetX controller.
///
/// [AddGuideScreen] (hem admin hem SA) bu controller'ı kullanır.
/// [FirestoreService] + [AuthService] core servisleri üzerinden çalışır;
/// admin/super_admin servis dosyalarına bağımlılık yoktur.
class GuideController extends GetxController {
  final FirestoreService _db;

  GuideController({required FirestoreService db}) : _db = db;

  // ─── Reaktif State ─────────────────────────────────────────────────────────

  final isLoading = false.obs;

  // ─── Rehber Ekle ───────────────────────────────────────────────────────────

  /// Turu'a rehber ekler:
  /// 1. Firebase Auth'ta rehber hesabı oluşturulur (mevcut oturum bozulmaz).
  /// 2. `users` koleksiyonuna rehber dokümanı yazılır.
  /// 3. İlgili tur dokümanı `guideId` ve `guideName` ile güncellenir.
  Future<bool> addGuide({
    required String guideId,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    isLoading.value = true;
    try {
      final normalized = AuthService.normalizeGuideId(guideId);
      final email = AuthService.buildGuideLoginEmail(normalized);

      // Mevcut admin/SA oturumunu bozmadan ikincil Firebase App üzerinden
      // yeni rehber hesabı oluşturulur
      final uid = await AuthService.createSecondaryAuthUser(email, password);

      final guide = UserModel(
        uid: uid,
        loginId: normalized,
        email: email,
        fullName: fullName,
        phone: phone,
        role: 'guide',
        companyId: companyId,
        guidePassword: password,
        isDeleted: false,
      );

      await _db.setDocument('users', uid, guide.toMap());

      // Tur dokümanına rehber ID'si ve adı eklenir
      await _db.updateDocument('tours', tourId, {'guideId': uid, 'guideName': fullName});

      return true;
    } catch (e) {
      _showError(_friendlyError(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Yardımcılar ───────────────────────────────────────────────────────────

  String _friendlyError(Object error) {
    final msg = error.toString();
    if (msg.contains('email-already-in-use')) {
      return 'Bu Guide ID zaten kullanılıyor.';
    }
    if (msg.contains('weak-password')) return 'Şifre en az 6 karakter olmalıdır.';
    if (msg.contains('invalid-email')) return 'Guide ID formatı geçersiz.';
    return 'İşlem başarısız: $msg';
  }

  void _showError(String msg) => Get.snackbar('Hata', msg, snackPosition: SnackPosition.BOTTOM);
}
