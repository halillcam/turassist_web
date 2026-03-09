import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../participants/presentation/controllers/participant_controller.dart';

class AddParticipantScreen extends StatefulWidget {
  final String tourId;
  final DateTime? departureDate;

  const AddParticipantScreen({super.key, required this.tourId, this.departureDate});

  @override
  State<AddParticipantScreen> createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  late final ParticipantController _controller;
  final _formKey = GlobalKey<FormState>();
  final _participantIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _tcNoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String get _normalizedId => AuthService.normalizePanelLoginId(_participantIdCtrl.text);
  String get _loginEmail =>
      _normalizedId.isEmpty ? '' : AuthService.buildCustomerLoginEmail(_normalizedId);

  @override
  void initState() {
    super.initState();
    // Binding tarafindan enjekte edilen ParticipantController alinir
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

    // Sirket kimligi oturum bilgisinden okunur; ekstra admin controller gerekmez.
    final companyId = Get.find<AuthController>().currentUser.value?.companyId;
    if (companyId == null || companyId.isEmpty) {
      Get.snackbar(
        'Hata',
        'Sirket bilgisi alinamadi',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final participantId = _normalizedId;
    final password = _passwordCtrl.text.trim();

    // Controller hata/basari mesajlarini icsel olarak yonetir
    final success = await _controller.addParticipant(
      loginId: participantId,
      password: password,
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      tcNo: _tcNoCtrl.text.trim(),
      tourId: widget.tourId,
      companyId: companyId,
      pricePaid: double.tryParse(_priceCtrl.text) ?? 0,
      departureDate: widget.departureDate,
    );

    if (success && mounted) {
      await _showCredentialsDialog(participantId: participantId, password: password);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _showCredentialsDialog({required String participantId, required String password}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Katilimci olusturuldu'),
        content: SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asagidaki giris bilgilerini musteriye iletin.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _CredentialItem(label: 'Musteri ID', value: participantId),
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
              child: SingleChildScrollView(
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
                      'Fiziksel satis icin musteri hesabi olusturulur. Bu hesap mobil uygulamaya erisir.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    if (widget.departureDate != null) ...[
                      const SizedBox(height: 8),
                      _DateBadge(date: widget.departureDate!),
                    ],
                    const SizedBox(height: 24),
                    _field('Ad Soyad *', _fullNameCtrl, required: true),
                    const SizedBox(height: 12),
                    _field('TC No', _tcNoCtrl, keyboard: TextInputType.number),
                    const SizedBox(height: 12),
                    _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                    const SizedBox(height: 12),
                    _field(
                      'Musteri ID *',
                      _participantIdCtrl,
                      required: true,
                      onChanged: (_) => setState(() {}),
                      helperText: _loginEmail.isEmpty
                          ? 'Sistem giris tanimlayicisini otomatik uretir.'
                          : 'Giris tanimlayicisi: $_loginEmail',
                      validator: (v) {
                        final id = AuthService.normalizePanelLoginId(v ?? '');
                        if (id.isEmpty) return 'Musteri ID zorunlu';
                        if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(id))
                          return 'Sadece harf, rakam ve tire kullanin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _field(
                      'Sifre *',
                      _passwordCtrl,
                      obscure: true,
                      required: true,
                      validator: (v) {
                        final p = (v ?? '').trim();
                        if (p.isEmpty) return 'Sifre zorunlu';
                        if (p.length < 6) return 'En az 6 karakter girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _field('Odenen Tutar', _priceCtrl, keyboard: TextInputType.number),
                    const SizedBox(height: 24),
                    // isLoading reaktif olarak controller uzerinden izlenir
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _controller.isLoading.value ? null : _handleAdd,
                          icon: _controller.isLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.person_add),
                          label: Text(
                            _controller.isLoading.value ? 'Ekleniyor...' : AppStrings.add,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// Kucuk dumb widget'lar
// ---------------------------------------------------------------------------

class _DateBadge extends StatelessWidget {
  final DateTime date;
  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Cikis: ${DateFormat('dd.MM.yyyy').format(date)}',
            style: const TextStyle(color: AppColors.primary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CredentialItem extends StatelessWidget {
  final String label;
  final String value;
  const _CredentialItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
}
