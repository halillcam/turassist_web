import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../../users/presentation/controllers/user_controller.dart';

class SaAddUserScreen extends StatefulWidget {
  const SaAddUserScreen({super.key});

  @override
  State<SaAddUserScreen> createState() => _SaAddUserScreenState();
}

class _SaAddUserScreenState extends State<SaAddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _tcNoCtrl = TextEditingController();

  String _selectedRole = 'customer';
  String? _selectedCompanyId;
  bool _obscurePassword = true;

  late final UserController _uc;
  late final CompanyController _cc;

  static const _roles = [('customer', 'Müşteri'), ('guide', 'Rehber'), ('admin', 'Admin')];

  @override
  void initState() {
    super.initState();
    _uc = Get.find<UserController>();
    _cc = Get.find<CompanyController>();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _tcNoCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;
    // Controller isLoading'i reaktif olarak yönetir.
    final ok = await _uc.addUser(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      role: _selectedRole,
      companyId: _selectedCompanyId ?? '',
      tcNo: _tcNoCtrl.text.trim(),
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Card(
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yeni Kullanıcı',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Oluşturulan bilgilerle mobil uygulamadan giriş yapılabilir.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Ad Soyad
                    _field('Ad Soyad *', _fullNameCtrl, required: true),
                    const SizedBox(height: 12),

                    // TC No
                    _field('TC No', _tcNoCtrl, keyboard: TextInputType.number),
                    const SizedBox(height: 12),

                    // Telefon
                    _field('Telefon *', _phoneCtrl, keyboard: TextInputType.phone, required: true),
                    const SizedBox(height: 12),

                    // E-posta
                    _field(
                      'E-posta *',
                      _emailCtrl,
                      keyboard: TextInputType.emailAddress,
                      required: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
                        if (!v.contains('@')) return 'Geçerli bir e-posta girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Şifre
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Şifre *',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.slate400,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Şifre gerekli';
                        if (v.length < 6) return 'Şifre en az 6 karakter olmalı';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Rol seçimi
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Rol *',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: _roles
                          .map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$2)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Şirket seçimi
                    Obx(() {
                      return DropdownButtonFormField<String?>(
                        initialValue: _selectedCompanyId,
                        decoration: InputDecoration(
                          labelText: 'Şirket',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Şirket seçilmedi'),
                          ),
                          ..._cc.activeCompanies.map(
                            (c) =>
                                DropdownMenuItem<String?>(value: c.id, child: Text(c.companyName)),
                          ),
                        ],
                        onChanged: (val) => setState(() => _selectedCompanyId = val),
                      );
                    }),
                    const SizedBox(height: 28),

                    Obx(() {
                      final loading = _uc.isLoading.value;
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
                          label: Text(loading ? 'Oluşturuluyor...' : AppStrings.add),
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
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator:
          validator ??
          (required ? (v) => (v == null || v.trim().isEmpty) ? '$label gerekli' : null : null),
    );
  }
}
