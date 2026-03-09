import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../companies/presentation/controllers/company_controller.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyTitleCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();

  @override
  void dispose() {
    _companyTitleCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _fullNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAddCompany() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = Get.find<CompanyController>();

    try {
      await controller.addCompany(
        companyName: _companyTitleCtrl.text.trim(),
        fullName: _fullNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      _companyTitleCtrl.clear();
      _emailCtrl.clear();
      _passwordCtrl.clear();
      _phoneCtrl.clear();
      _fullNameCtrl.clear();
    } catch (_) {
      // Snackbar zaten controller'da gösteriliyor
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addCompany)),
      body: Center(
        child: Card(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.addCompany,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Şirket eklendiğinde oluşturulan ID/PW ile admin olarak web paneline giriş yapılabilir.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Şirket Adı',
                    controller: _companyTitleCtrl,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Ad Soyad',
                    controller: _fullNameCtrl,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Telefon No',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'E-posta (ID)',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Şifre',
                    controller: _passwordCtrl,
                    obscureText: true,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => CustomButton(
                        text: AppStrings.save,
                        onPressed: _handleAddCompany,
                        isLoading: controller.isLoading.value,
                        icon: Icons.business,
                      ),
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
