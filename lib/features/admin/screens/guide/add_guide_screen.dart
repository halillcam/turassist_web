import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../controllers/admin_tour_controller.dart';

class AddGuideScreen extends StatefulWidget {
  final String tourId;

  const AddGuideScreen({super.key, required this.tourId});

  @override
  State<AddGuideScreen> createState() => _AddGuideScreenState();
}

class _AddGuideScreenState extends State<AddGuideScreen> {
  late final AdminTourController _controller;
  final _formKey = GlobalKey<FormState>();
  final _guideIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  String get _normalizedGuideId => AuthService.normalizeGuideId(_guideIdCtrl.text);

  String get _generatedLoginEmail =>
      _normalizedGuideId.isEmpty ? '' : AuthService.buildGuideLoginEmail(_normalizedGuideId);

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminTourController>();
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
    setState(() => _isLoading = true);

    try {
      final companyId = await _controller.getCurrentCompanyId();
      if (companyId == null) throw Exception('Şirket bilgisi alınamadı');

      final guideId = _normalizedGuideId;
      final password = _passwordCtrl.text.trim();

      await _controller.addGuideToTour(
        guideId: guideId,
        password: password,
        fullName: _fullNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        tourId: widget.tourId,
        companyId: companyId,
      );

      if (!mounted) return;
      await _showCredentialsDialog(guideId: guideId, password: password);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyError(e)), backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('email-already-in-use')) {
      return 'Bu Guide ID zaten kullanılıyor.';
    }
    if (message.contains('weak-password')) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    if (message.contains('invalid-email')) {
      return 'Guide ID formatı geçersiz.';
    }
    return 'İşlem başarısız: $message';
  }

  Future<void> _showCredentialsDialog({required String guideId, required String password}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Tur sorumlusu oluşturuldu'),
        content: SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aşağıdaki giriş bilgilerini tur sorumlusuna iletin.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _credentialItem('Guide ID', guideId),
              const SizedBox(height: 12),
              _credentialItem('Şifre', password),
            ],
          ),
        ),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
        ],
      ),
    );
  }

  Widget _credentialItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: SelectableText(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
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
                    AppStrings.addGuide,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tur sorumlusu için ID ve şifre oluşturulur.\n'
                    'Mobil uygulamada tur sorumlusu olarak giriş yapar.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  _field(
                    'Guide ID *',
                    _guideIdCtrl,
                    required: true,
                    onChanged: (_) => setState(() {}),
                    helperText: _generatedLoginEmail.isEmpty
                        ? 'Sistem giriş tanımlayıcısını otomatik üretir.'
                        : 'Giriş tanımlayıcısı: $_generatedLoginEmail',
                    validator: (value) {
                      final guideId = AuthService.normalizeGuideId(value ?? '');
                      if (guideId.isEmpty) return 'Guide ID zorunlu';
                      if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(guideId)) {
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
                          : const Icon(Icons.admin_panel_settings),
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
    String? helperText,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
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
