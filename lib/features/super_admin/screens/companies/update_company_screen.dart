import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class UpdateCompanyScreen extends StatefulWidget {
  final String companyId;

  const UpdateCompanyScreen({super.key, required this.companyId});

  @override
  State<UpdateCompanyScreen> createState() => _UpdateCompanyScreenState();
}

class _UpdateCompanyScreenState extends State<UpdateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyTitleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    // TODO: Firestore'dan şirket verisi çekilecek
  }

  @override
  void dispose() {
    _companyTitleController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Firestore'da şirket güncellenecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.updateCompany)),
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
                    AppStrings.updateCompany,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Şirket Adı',
                    controller: _companyTitleController,
                    validator: (v) =>
                        v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Ad Soyad',
                    controller: _fullNameController,
                    validator: (v) =>
                        v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  CustomTextField(
                    label: 'Telefon No',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v?.isEmpty == true ? 'Zorunlu alan' : null,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Şirket Aktif'),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: AppStrings.update,
                      onPressed: _handleUpdate,
                      isLoading: _isLoading,
                      icon: Icons.edit,
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
