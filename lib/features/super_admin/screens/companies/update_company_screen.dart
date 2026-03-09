import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/models/user_model.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../../users/presentation/controllers/user_controller.dart';

class UpdateCompanyScreen extends StatefulWidget {
  final String companyId;

  const UpdateCompanyScreen({super.key, required this.companyId});

  @override
  State<UpdateCompanyScreen> createState() => _UpdateCompanyScreenState();
}

class _UpdateCompanyScreenState extends State<UpdateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyTitleCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  bool _isActive = true;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    try {
      // Sirket verisi merkezi CompanyController uzerinden alinir.
      final company = await Get.find<CompanyController>().getCompany(widget.companyId);
      if (company == null || !mounted) return;

      _companyTitleCtrl.text = company.companyName;
      _phoneCtrl.text = company.contactPhone;
      _isActive = company.status;

      if (company.adminUid.isNotEmpty) {
        // Admin adi, UserController'in onbellekli listesinden bulunur
        final UserModel? admin = Get.find<UserController>().allUsers.firstWhereOrNull(
          (u) => u.uid == company.adminUid,
        );
        if (admin != null && mounted) {
          _fullNameCtrl.text = admin.fullName;
        }
      }

      if (mounted) setState(() => _isDataLoaded = true);
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Hata',
          'Sirket verileri yuklenemedi: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void dispose() {
    _companyTitleCtrl.dispose();
    _phoneCtrl.dispose();
    _fullNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<CompanyController>();
    try {
      await controller.updateCompany(widget.companyId, {
        'companyName': _companyTitleCtrl.text.trim(),
        'contactPhone': _phoneCtrl.text.trim(),
        'status': _isActive,
      });
      if (mounted) Navigator.pop(context);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.updateCompany)),
      body: !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Şirket Aktif'),
                          value: _isActive,
                          onChanged: (val) => setState(() => _isActive = val),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => CustomButton(
                              text: AppStrings.update,
                              onPressed: _handleUpdate,
                              isLoading: controller.isLoading.value,
                              icon: Icons.edit,
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
