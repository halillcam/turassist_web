import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class AddGuideScreen extends StatefulWidget {
  final String tourId;

  const AddGuideScreen({super.key, required this.tourId});

  @override
  State<AddGuideScreen> createState() => _AddGuideScreenState();
}

class _AddGuideScreenState extends State<AddGuideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAddGuide() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Firebase Auth ile tur sorumlusu oluşturulacak
    // Oluşturulan user'ın id'si ilgili tur'un guide_id'sine yazılacak
    // Mobil app'ten girdiğinde tur sorumlusu olarak girecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addGuide)),
      body: Center(
        child: Card(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.addGuide,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tur sorumlusu için özel ID ve şifre oluşturulur. '
                    'Oluşturulan kullanıcı mobil uygulamada tur sorumlusu olarak giriş yapar.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'E-posta (ID)',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Şifre',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: AppStrings.add,
                      onPressed: _handleAddGuide,
                      isLoading: _isLoading,
                      icon: Icons.admin_panel_settings,
                    ),
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
