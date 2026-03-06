import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../services/super_admin_service.dart';

class SaAddParticipantScreen extends StatefulWidget {
  final String tourId;
  final String companyId;

  const SaAddParticipantScreen({super.key, required this.tourId, required this.companyId});

  @override
  State<SaAddParticipantScreen> createState() => _SaAddParticipantScreenState();
}

class _SaAddParticipantScreenState extends State<SaAddParticipantScreen> {
  final _service = SuperAdminService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _tcNoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _tcNoCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _service.addParticipantToTour(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        fullName: _fullNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        tcNo: _tcNoCtrl.text.trim(),
        tourId: widget.tourId,
        companyId: widget.companyId,
        pricePaid: double.tryParse(_priceCtrl.text) ?? 0,
      );

      Get.snackbar('Başarılı', 'Katılımcı başarıyla eklendi.', snackPosition: SnackPosition.BOTTOM);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addParticipant),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    AppStrings.addParticipant,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Oluşturulan ID ve şifre ile mobil uygulamadan giriş yapılabilir.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _field('Ad Soyad *', _fullNameCtrl, required: true),
                  const SizedBox(height: 12),
                  _field('TC No', _tcNoCtrl, keyboard: TextInputType.number),
                  const SizedBox(height: 12),
                  _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                  const SizedBox(height: 12),
                  _field(
                    'E-posta (ID) *',
                    _emailCtrl,
                    keyboard: TextInputType.emailAddress,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _field('Şifre *', _passwordCtrl, obscure: true, required: true),
                  const SizedBox(height: 12),
                  _field('Ödenen Tutar (₺)', _priceCtrl, keyboard: TextInputType.number),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleAdd,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.person_add),
                      label: Text(_isLoading ? 'Ekleniyor...' : AppStrings.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    bool required = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null : null,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
