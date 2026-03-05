import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _companyTitleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleAddCompany() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Firebase Auth ile admin kullanıcı oluşturulacak
    // Şirket Firestore'a kaydedilecek
    // Oluşturulan kullanıcı admin rolü alacak, yalnızca web ile giriş yapabilecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _companyTitleController,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Ad Soyad',
                    controller: _fullNameController,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Telefon No',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
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
                      text: AppStrings.save,
                      onPressed: _handleAddCompany,
                      isLoading: _isLoading,
                      icon: Icons.business,
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
