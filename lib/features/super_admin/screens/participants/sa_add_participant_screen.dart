import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../services/super_admin_service.dart';

class SaAddParticipantScreen extends StatefulWidget {
  final String tourId;
  final String companyId;
  final DateTime? departureDate;

  const SaAddParticipantScreen({
    super.key,
    required this.tourId,
    required this.companyId,
    this.departureDate,
  });

  @override
  State<SaAddParticipantScreen> createState() => _SaAddParticipantScreenState();
}

class _SaAddParticipantScreenState extends State<SaAddParticipantScreen> {
  final _service = SuperAdminService();
  final _formKey = GlobalKey<FormState>();
  final _participantIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _tcNoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isLoading = false;

  String get _normalizedParticipantId => AuthService.normalizePanelLoginId(_participantIdCtrl.text);

  String get _generatedLoginEmail => _normalizedParticipantId.isEmpty
      ? ''
      : AuthService.buildCustomerLoginEmail(_normalizedParticipantId);

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
    setState(() => _isLoading = true);

    try {
      final participantId = _normalizedParticipantId;
      final password = _passwordCtrl.text.trim();

      await _service.addParticipantToTour(
        loginId: participantId,
        password: password,
        fullName: _fullNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        tcNo: _tcNoCtrl.text.trim(),
        tourId: widget.tourId,
        companyId: widget.companyId,
        pricePaid: double.tryParse(_priceCtrl.text) ?? 0,
        departureDate: widget.departureDate,
      );

      if (!mounted) return;
      await _showCredentialsDialog(participantId: participantId, password: password);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Hata', _friendlyError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('login-id-already-in-use')) {
      return 'Bu Müşteri ID başka bir panel hesabında zaten kullanılıyor.';
    }
    if (message.contains('email-already-in-use')) {
      return 'Bu Müşteri ID zaten kullanılıyor.';
    }
    if (message.contains('weak-password')) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    if (message.contains('invalid-email')) {
      return 'Müşteri ID formatı geçersiz.';
    }
    return 'İşlem başarısız: $message';
  }

  Future<void> _showCredentialsDialog({required String participantId, required String password}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Katılımcı oluşturuldu'),
        content: SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aşağıdaki giriş bilgilerini müşteriye iletin. Bu hesap bilet oluşturulmuş ve QR okutulmuş gibi hazırlanır.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _credentialItem('Müşteri ID', participantId),
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
                    'Fiziksel satış için müşteri hesabı oluşturulur. Bu hesap, bilet satın alınmış ve QR okutulmuş gibi mobil uygulamaya erişir.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  if (widget.departureDate != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Çıkış: ${DateFormat('dd.MM.yyyy').format(widget.departureDate!)}',
                            style: const TextStyle(color: AppColors.primary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _field('Ad Soyad *', _fullNameCtrl, required: true),
                  const SizedBox(height: 12),
                  _field('TC No', _tcNoCtrl, keyboard: TextInputType.number),
                  const SizedBox(height: 12),
                  _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                  const SizedBox(height: 12),
                  _field(
                    'Müşteri ID *',
                    _participantIdCtrl,
                    required: true,
                    onChanged: (_) => setState(() {}),
                    helperText: _generatedLoginEmail.isEmpty
                        ? 'Sistem giriş tanımlayıcısını otomatik üretir.'
                        : 'Giriş tanımlayıcısı: $_generatedLoginEmail',
                    validator: (value) {
                      final participantId = AuthService.normalizePanelLoginId(value ?? '');
                      if (participantId.isEmpty) return 'Müşteri ID zorunlu';
                      if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(participantId)) {
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
