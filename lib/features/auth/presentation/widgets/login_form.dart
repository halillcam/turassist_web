import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

/// Giriş formunu içeren "dumb" widget.
///
/// İş mantığı yoktur; tüm aksiyonlar [AuthController]'a delege edilir.
/// State olarak yalnızca Form doğrulaması için [GlobalKey] tutulur.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Form(
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
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || v.isEmpty) ? 'E-posta gerekli' : null,
          ),
          CustomTextField(
            label: AppStrings.password,
            controller: controller.passwordController,
            obscureText: true,
            validator: (v) => (v == null || v.isEmpty) ? 'Şifre gerekli' : null,
          ),
          const SizedBox(height: 8),

          // Hata mesajı — sadece dolu olduğunda gösterilir
          Obx(() {
            final msg = controller.errorMessage.value;
            if (msg.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                msg,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            );
          }),

          const SizedBox(height: 16),

          // Giriş butonu — loading state'i reaktif olarak izler
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => CustomButton(
                text: AppStrings.login,
                isLoading: controller.isLoading.value,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.login();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
