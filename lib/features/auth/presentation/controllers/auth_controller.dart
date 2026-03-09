import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

class AuthController extends GetxController {
  final SignInUseCase _signIn;
  final SignOutUseCase _signOut;
  final GetCurrentUserUseCase _getCurrentUser;

  // TextEditingController lifecycle GetX tarafından yönetilir (onClose'da dispose edilir).
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ─── Reaktif State ────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserEntity?> currentUser = Rx(null);

  /// AuthGate tarafından dinlenir: null=yükleniyor, false=oturum yok, true=oturum var
  final Rx<bool?> isAuthenticated = Rx(null);

  AuthController({
    required SignInUseCase signIn,
    required SignOutUseCase signOut,
    required GetCurrentUserUseCase getCurrentUser,
  }) : _signIn = signIn,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser;

  @override
  void onInit() {
    super.onInit();
    checkAuthState();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ─── Auth Durumu Kontrolü (AuthGate için) ────────────────────────────────

  /// Uygulama açıldığında Firestore'dan mevcut kullanıcıyı okur ve
  /// [isAuthenticated] ile [currentUser] state'lerini günceller.
  Future<void> checkAuthState() async {
    final result = await _getCurrentUser();
    result.fold((_) => isAuthenticated.value = false, (user) {
      currentUser.value = user;
      isAuthenticated.value = user != null;
    });
  }

  // ─── Giriş ───────────────────────────────────────────────────────────────

  Future<void> login() async {
    errorMessage.value = '';
    isLoading.value = true;

    final result = await _signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    result.fold((failure) => errorMessage.value = failure.message, (user) {
      currentUser.value = user;
      _navigateByRole(user.role);
    });

    isLoading.value = false;
  }

  // ─── Çıkış ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final result = await _signOut();
    result.fold(
      (failure) => Get.snackbar(
        'Hata',
        failure.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      ),
      (_) {
        currentUser.value = null;
        isAuthenticated.value = false;
        // offAllNamed route'ları temizler; binding dispose olunca
        // tüm Firestore stream abonelikleri iptal edilir.
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  // ─── Yardımcılar ─────────────────────────────────────────────────────────

  void _navigateByRole(UserRole role) {
    final route = switch (role) {
      UserRole.superAdmin => AppRoutes.superAdminDashboard,
      UserRole.admin => AppRoutes.adminDashboard,
    };
    Get.offAllNamed(route);
  }
}
