import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/guide_controller.dart';
import '../widgets/guide_credentials_dialog.dart';

class GuideAddScreen extends StatefulWidget {
  final String tourId;
  final String companyId;

  const GuideAddScreen({super.key, required this.tourId, required this.companyId});

  @override
  State<GuideAddScreen> createState() => _GuideAddScreenState();
}

class _GuideAddScreenState extends State<GuideAddScreen> {
  late final GuideController _controller;
  final _formKey = GlobalKey<FormState>();
  final _guideIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String get _normalizedGuideId => _controller.normalizeGuideId(_guideIdCtrl.text);
  String get _loginEmail => _controller.buildGuideLoginEmail(_guideIdCtrl.text);

  @override
  void initState() {
    super.initState();
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

    final guideId = _normalizedGuideId;
    final password = _passwordCtrl.text.trim();
    final success = await _controller.addGuide(
      guideId: guideId,
      password: password,
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      tourId: widget.tourId,
      companyId: widget.companyId,
    );

    if (!success || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GuideCredentialsDialog(guideId: guideId, password: password),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addGuide),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Card(
          child: SizedBox(
            width: 500,
            child: Padding(
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tur sorumlusu için ID ve şifre oluşturulur. Mobil uygulamada tur sorumlusu olarak giriş yapar.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    _field(
                      'Guide ID *',
                      _guideIdCtrl,
                      required: true,
                      onChanged: (_) => setState(() {}),
                      helperText: _loginEmail.isEmpty
                          ? 'Sistem giriş tanımlayıcısını otomatik üretir.'
                          : 'Giriş tanımlayıcısı: $_loginEmail',
                      validator: (value) {
                        final guideId = _controller.normalizeGuideId(value ?? '');
                        if (guideId.isEmpty) return 'Guide ID zorunlu';
                        if (!_controller.isValidGuideId(value ?? '')) {
                          return 'Sadece harf, rakam ve tire kullanın';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _field('Ad Soyad *', _fullNameCtrl, required: true),
                    const SizedBox(height: 12),
                    _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                    const SizedBox(height: 12),
                    _field(
                      'Şifre *',
                      _passwordCtrl,
                      obscure: true,
                      required: true,
                      validator: (value) {
                        final password = (value ?? '').trim();
                        if (password.isEmpty) return 'Şifre zorunlu';
                        if (password.length < 6) return 'En az 6 karakter girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      final loading = _controller.isLoading.value;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : _handleAdd,
                          icon: loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.admin_panel_settings),
                          label: Text(loading ? 'Ekleniyor...' : AppStrings.add),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    bool required = false,
    String? helperText,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      onChanged: onChanged,
      validator:
          validator ??
          (required ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null : null),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}