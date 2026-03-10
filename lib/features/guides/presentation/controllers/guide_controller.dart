import 'package:get/get.dart';

import '../../domain/usecases/add_guide_usecase.dart';

class GuideController extends GetxController {
  static const _guideEmailDomain = 'guide.turassist';

  final AddGuideUseCase _addGuide;

  GuideController({required AddGuideUseCase addGuide}) : _addGuide = addGuide;

  final isLoading = false.obs;

  String normalizeGuideId(String rawValue) => rawValue.trim().toUpperCase();

  String buildGuideLoginEmail(String rawValue) {
    final normalized = normalizeGuideId(rawValue);
    return normalized.isEmpty ? '' : '$normalized@$_guideEmailDomain';
  }

  bool isValidGuideId(String rawValue) {
    final normalized = normalizeGuideId(rawValue);
    return normalized.isNotEmpty && RegExp(r'^[A-Z0-9-]+$').hasMatch(normalized);
  }

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
      final result = await _addGuide(
        AddGuideParams(
          guideId: guideId,
          password: password,
          fullName: fullName,
          phone: phone,
          tourId: tourId,
          companyId: companyId,
        ),
      );
      result.fold((failure) => throw StateError(failure.message), (_) {});
      return true;
    } catch (error) {
      _showError(_friendlyError(error));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyError(Object error) {
    final msg = error.toString();
    if (msg.contains('email-already-in-use')) {
      return 'Bu Guide ID zaten kullanılıyor.';
    }
    if (msg.contains('weak-password')) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    if (msg.contains('invalid-email')) {
      return 'Guide ID formatı geçersiz.';
    }
    return 'İşlem başarısız: $msg';
  }

  void _showError(String msg) {
    Get.snackbar('Hata', msg, snackPosition: SnackPosition.BOTTOM);
  }
}