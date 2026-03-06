import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// E-posta ve şifreyi doğrular, kullanıcının rolüne göre ilgili dashboard'a yönlendirir.
  /// Hesap silinmiş ya da rol tanımsızsa hata snackbar'ı gösterir.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (user == null) {
        _showError('Kullanıcı bulunamadı. Lütfen bilgilerinizi kontrol edin.');
        return;
      }

      final route = switch (user.role) {
        'super_admin' => AppRoutes.superAdminDashboard,
        'admin' => AppRoutes.adminDashboard,
        _ => null,
      };

      if (route == null) {
        _showError('Bu hesabın bu panele erişim izni bulunmuyor. (Rol: ${user.role})');
        return;
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
      }
    } catch (e) {
      _showError(_friendlyError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Firebase/StateError mesajlarını kullanıcı dostu Türkçe'ye çevirir.
  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('user-not-found') || msg.contains('invalid-credential')) {
      return 'E-posta veya şifre hatalı.';
    }
    if (msg.contains('wrong-password')) return 'Şifre hatalı.';
    if (msg.contains('invalid-email')) return 'Geçersiz e-posta adresi.';
    if (msg.contains('too-many-requests')) return 'Çok fazla deneme. Lütfen bekleyin.';
    if (msg.contains('network-request-failed')) return 'İnternet bağlantısı yok.';
    if (msg.contains('devre dışı')) return msg.replaceFirst('Bad state: ', '');
    return 'Giriş başarısız: $msg';
  }

  void _showError(String message) {
    Get.snackbar(
      'Giriş Başarısız',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.travel_explore, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.loginTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: AppStrings.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta gerekli';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: AppStrings.password,
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre gerekli';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: AppStrings.login,
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Test Navigasyonu',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.adminDashboard),
                          icon: const Icon(Icons.admin_panel_settings, size: 18),
                          label: const Text('Admin UI'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.superAdminDashboard),
                          icon: const Icon(Icons.shield, size: 18),
                          label: const Text('Super Admin UI'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
