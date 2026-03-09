import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../presentation/widgets/login_form.dart';

/// Giriş ekranı — scaffold ve kart düzeninden sorumludur.
///
/// İş mantığı yoktur; form içeriği ve controller etkileşimi
/// [LoginForm] ve [AuthController] tarafından yönetilir.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(width: 420, padding: const EdgeInsets.all(32), child: const LoginForm()),
        ),
      ),
    );
  }
}
