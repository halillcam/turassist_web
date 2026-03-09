import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../communication/presentation/controllers/communication_controller.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../../completion/presentation/controllers/completion_controller.dart';
import '../../../feedback/presentation/controllers/feedback_controller.dart';
import '../../../guides/presentation/controllers/guide_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../../../participants/presentation/controllers/participant_controller.dart';
import '../../../tours/presentation/controllers/tour_controller.dart';
import '../../../users/presentation/controllers/user_controller.dart';
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
    if (isLoading.value) return;
    isLoading.value = true;
    Get.closeAllSnackbars();

    // Yetki düşmeden önce role-scope controller'ları kapatır.
    _disposeSessionControllers();

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
        _resetAuthState();
        // Tüm route geçmişini temizler; geri tuşu ile yetkili ekrana dönülemez.
        Get.offAllNamed(AppRoutes.login);
      },
    );
    isLoading.value = false;
  }

  // ─── Yardımcılar ─────────────────────────────────────────────────────────

  void _navigateByRole(UserRole role) {
    final route = switch (role) {
      UserRole.superAdmin => AppRoutes.superAdminDashboard,
      UserRole.admin => AppRoutes.adminDashboard,
    };
    Get.offAllNamed(route);
  }

  void _resetAuthState() {
    currentUser.value = null;
    isAuthenticated.value = false;
    errorMessage.value = '';
    emailController.clear();
    passwordController.clear();
  }

  void _disposeSessionControllers() {
    _deleteIfRegistered<CommunicationController>();
    _deleteIfRegistered<CompletionController>();
    _deleteIfRegistered<CompanyController>();
    _deleteIfRegistered<FeedbackController>();
    _deleteIfRegistered<GuideController>();
    _deleteIfRegistered<NotificationController>();
    _deleteIfRegistered<ParticipantController>();
    _deleteIfRegistered<TourController>();
    _deleteIfRegistered<UserController>();
  }

  void _deleteIfRegistered<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>(force: true);
    }
  }
}
