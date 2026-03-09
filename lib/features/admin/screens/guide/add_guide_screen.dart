import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../../guides/presentation/controllers/guide_controller.dart';
import '../../controllers/admin_dashboard_controller.dart';

class AddGuideScreen extends StatefulWidget {
  final String tourId;

  const AddGuideScreen({super.key, required this.tourId});

  @override
  State<AddGuideScreen> createState() => _AddGuideScreenState();
}

class _AddGuideScreenState extends State<AddGuideScreen> {
  late final GuideController _controller;
  final _formKey = GlobalKey<FormState>();
  final _guideIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String get _normalizedGuideId => AuthService.normalizeGuideId(_guideIdCtrl.text);
  String get _loginEmail =>
      _normalizedGuideId.isEmpty ? '' : AuthService.buildGuideLoginEmail(_normalizedGuideId);

  @override
  void initState() {
    super.initState();
    // Binding tarafindan enjekte edilen GuideController alinir
    _controller = Get.find<GuideController>();
  }

  @override
  void dispose() {
    _guideIdCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    // companyId AdminDashboardController uzerinden alinir
    final companyId = Get.find<AdminDashboardController>().companyId.value;
    if (companyId == null) {
      Get.snackbar('Hata', 'Sirket bilgisi alinamadi',
          backgroundColor: AppColors.error, colorText: Colors.white);
      return;
    }

    final guideId = _normalizedGuideId;
    final password = _passwordCtrl.text.trim();

    // Controller hata mesajlarini icsel olarak yonetir
    final success = await _controller.addGuide(
      guideId: guideId,
      password: password,
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      tourId: widget.tourId,
      companyId: companyId,
    );

    if (success && mounted) {
      await _showCredentialsDialog(guideId: guideId, password: password);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _showCredentialsDialog({
    required String guideId,
    required String password,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Tur sorumlusu olusturuldu'),
        content: SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asagidaki giris bilgilerini tur sorumlusuna iletin.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _CredentialItem(label: 'Guide ID', value: guideId),
              const SizedBox(height: 12),
              _CredentialItem(label: 'Sifre', value: password),
            ],
          ),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addGuide),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
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
                  const Text(AppStrings.addGuide,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text(
                    'Tur sorumlusu icin ID ve sifre olusturulur. Mobil uygulamada tur sorumlusu olarak giris yapar.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    'Guide ID *', _guideIdCtrl,
                    required: true,
                    onChanged: (_) => setState(() {}),
                    helperText: _loginEmail.isEmpty
                        ? 'Sistem giris tanimlayicisini otomatik uretir.'
                        : 'Giris tanimlayicisi: $_loginEmail',
                    validator: (v) {
                      final id = AuthService.normalizeGuideId(v ?? '');
                      if (id.isEmpty) return 'Guide ID zorunlu';
                      if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(id)) return 'Sadece harf, rakam ve tire kullanin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _field('Ad Soyad *', _fullNameCtrl, required: true),
                  const SizedBox(height: 12),
                  _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                  const SizedBox(height: 12),
                  _field('Sifre *', _passwordCtrl, obscure: true, required: true,
                      validator: (v) {
                        final p = (v ?? '').trim();
                        if (p.isEmpty) return 'Sifre zorunlu';
                        if (p.length < 6) return 'En az 6 karakter girin';
                        return null;
                      }),
                  const SizedBox(height: 24),
                  // isLoading reaktif olarak controller uzerinden izlenir
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _controller.isLoading.value ? null : _handleAdd,
                      icon: _controller.isLoading.value
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.admin_panel_settings),
                      label: Text(_controller.isLoading.value ? 'Ekleniyor...' : AppStrings.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false, bool required = false,
    String? helperText, String? Function(String?)? validator, ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: ctrl, keyboardType: keyboard, obscureText: obscure, onChanged: onChanged,
      validator: validator ?? (required ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null : null),
      decoration: InputDecoration(labelText: label, helperText: helperText, isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}

// ---------------------------------------------------------------------------
// Dumb widget  kimlik bilgisi gosterim satiri
// ---------------------------------------------------------------------------
class _CredentialItem extends StatelessWidget {
  final String label;
  final String value;
  const _CredentialItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.divider)),
          child: SelectableText(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}