import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/super_admin/screens/super_admin_dashboard_screen.dart';

/// Uygulamanın ilk açılış noktası.
///
/// [AuthController.isAuthenticated] değerini dinler:
///   - null  → yükleniyor (spinner)
///   - false → oturum yok, LoginScreen göster
///   - true  → [AuthController.currentUser] rolüne göre dashboard göster
///
/// Yönlendirme mantığı burada değil, [_resolveHome] metodunda kapsüllüdür.
/// Widget hiçbir iş mantığı içermez — sadece state'i okur ve widget döner.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Obx(() {
      final isAuthenticated = controller.isAuthenticated.value;

      // Henüz Firestore'dan yanıt gelmedi
      if (isAuthenticated == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Oturum yok
      if (isAuthenticated == false) {
        return const LoginScreen();
      }

      // Oturum var → role göre doğru ekranı döndür
      return _resolveHome(controller.currentUser.value);
    });
  }

  Widget _resolveHome(UserEntity? user) {
    if (user == null) return const LoginScreen();

    return switch (user.role) {
      UserRole.superAdmin => const SuperAdminDashboardScreen(),
      UserRole.admin => const AdminDashboardScreen(),
    };
  }
}
