import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/participant_controller.dart';
import '../widgets/participant_credentials_dialog.dart';
import '../widgets/participant_date_badge.dart';

class ParticipantAddScreen extends StatefulWidget {
  final String tourId;
  final String companyId;
  final DateTime? departureDate;

  const ParticipantAddScreen({
    super.key,
    required this.tourId,
    required this.companyId,
    this.departureDate,
  });

  @override
  State<ParticipantAddScreen> createState() => _ParticipantAddScreenState();
}

class _ParticipantAddScreenState extends State<ParticipantAddScreen> {
  late final ParticipantController _controller;
  final _formKey = GlobalKey<FormState>();
  final _participantIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _tcNoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String get _normalizedId => _controller.normalizeLoginId(_participantIdCtrl.text);
  String get _loginEmail => _controller.buildCustomerLoginEmail(_participantIdCtrl.text);

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ParticipantController>();
  }

  @override
  void dispose() {
    _participantIdCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _tcNoCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordCtrl.text.trim();
    final success = await _controller.addParticipant(
      loginId: _normalizedId,
      password: password,
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      tcNo: _tcNoCtrl.text.trim(),
      tourId: widget.tourId,
      companyId: widget.companyId,
      pricePaid: double.tryParse(_priceCtrl.text) ?? 0,
      departureDate: widget.departureDate,
    );

    if (!success || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          ParticipantCredentialsDialog(participantId: _normalizedId, password: password),
    );

    if (mounted) Navigator.pop(context);
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
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
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
                        'Fiziksel satış için müşteri hesabı oluşturulur. Bu hesap mobil uygulamaya erişir.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      if (widget.departureDate != null) ...[
                        const SizedBox(height: 8),
                        ParticipantDateBadge(date: widget.departureDate!),
                      ],
                      const SizedBox(height: 24),
                      _field('Ad Soyad *', _fullNameCtrl, required: true),
                      const SizedBox(height: 12),
                      _field('TC No', _tcNoCtrl, keyboard: TextInputType.number),
                      const SizedBox(height: 12),
                      _field(
                        'Telefon *',
                        _phoneCtrl,
                        keyboard: TextInputType.phone,
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        'Müşteri ID *',
                        _participantIdCtrl,
                        required: true,
                        onChanged: (_) => setState(() {}),
                        helperText: _loginEmail.isEmpty
                            ? 'Sistem giriş tanımlayıcısını otomatik üretir.'
                            : 'Giriş tanımlayıcısı: $_loginEmail',
                        validator: (value) {
                          final normalized = _controller.normalizeLoginId(value ?? '');
                          if (normalized.isEmpty) return 'Müşteri ID zorunlu';
                          if (!_controller.isValidLoginId(value ?? '')) {
                            return 'Sadece harf, rakam ve tire kullanın';
                          }
                          return null;
                        },
                      ),
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
                      const SizedBox(height: 12),
                      _field('Ödenen Tutar', _priceCtrl, keyboard: TextInputType.number),
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
                                : const Icon(Icons.person_add),
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
