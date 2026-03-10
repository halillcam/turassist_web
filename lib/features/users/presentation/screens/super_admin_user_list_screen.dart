import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../users/presentation/controllers/user_controller.dart';
import '../../../companies/presentation/controllers/company_controller.dart';
import '../../domain/entities/managed_user_entity.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  static const _roleLabels = {
    'customer': 'Müşteri',
    'guide': 'Rehber',
    'admin': 'Admin',
    'super_admin': 'Super Admin',
  };

  static const _roleColors = {
    'customer': AppColors.info,
    'guide': AppColors.warning,
    'admin': AppColors.success,
    'super_admin': AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.userList)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.saAddUser),
        icon: const Icon(Icons.person_add),
        label: const Text('Kullanıcı Ekle'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.userList,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilters(controller),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final users = controller.filteredUsers;
                if (controller.allUsers.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: AppColors.slate300),
                        SizedBox(height: 16),
                        Text(
                          'Kullanıcı bulunmuyor.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'Filtreye uygun kullanıcı bulunamadı.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceOverlayDark),
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Ad Soyad')),
                        DataColumn(label: Text('E-posta')),
                        DataColumn(label: Text('Telefon')),
                        DataColumn(label: Text('Rol')),
                        DataColumn(label: Text('Şirket')),
                        DataColumn(label: Text('Durum')),
                        DataColumn(label: Text('İşlemler')),
                      ],
                      rows: users.asMap().entries.map((entry) {
                        final i = entry.key;
                        final u = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${i + 1}')),
                            DataCell(Text(u.fullName)),
                            DataCell(Text(u.email)),
                            DataCell(Text(u.phone.isEmpty ? '-' : u.phone)),
                            DataCell(_roleChip(u.role)),
                            DataCell(Text(controller.companyNameOf(u.companyId))),
                            DataCell(_statusChip(!u.isDeleted)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: AppStrings.editUser,
                                    onPressed: () => _showEditDialog(context, controller, u),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: u.isDeleted
                                        ? AppStrings.activate
                                        : AppStrings.deactivate,
                                    onPressed: () =>
                                        controller.toggleUserActive(u.uid!, isActive: u.isDeleted),
                                    icon: Icon(
                                      u.isDeleted ? Icons.visibility : Icons.visibility_off,
                                      color: u.isDeleted ? AppColors.success : AppColors.warning,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: AppStrings.delete,
                                    onPressed: u.isDeleted
                                        ? null
                                        : () =>
                                              controller.toggleUserActive(u.uid!, isActive: false),
                                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(UserController controller) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ad, e-posta veya telefon ara...',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) => controller.searchQuery.value = val,
          ),
        ),
        const SizedBox(width: 16),
        Obx(
          () => DropdownButton<String>(
            value: controller.selectedRole.value,
            hint: const Text('Tüm Roller'),
            items: [
              const DropdownMenuItem(value: '', child: Text('Tüm Roller')),
              ..._roleLabels.entries.map(
                (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
              ),
            ],
            onChanged: (val) => controller.selectedRole.value = val ?? '',
          ),
        ),
        const SizedBox(width: 16),
        Obx(
          () => DropdownButton<bool?>(
            value: controller.selectedActive.value,
            hint: const Text('Tüm Durumlar'),
            items: const [
              DropdownMenuItem<bool?>(value: null, child: Text('Tüm Durumlar')),
              DropdownMenuItem<bool?>(value: true, child: Text('Aktif')),
              DropdownMenuItem<bool?>(value: false, child: Text('Pasif')),
            ],
            onChanged: (val) => controller.selectedActive.value = val,
          ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    UserController controller,
    ManagedUserEntity user,
  ) {
    return showDialog<void>(
      context: context,
      builder: (_) => _EditUserDialog(controller: controller, user: user),
    );
  }

  Widget _roleChip(String role) {
    final color = _roleColors[role] ?? AppColors.slate400;
    final label = _roleLabels[role] ?? role;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    final color = isActive ? AppColors.success : AppColors.error;
    final label = isActive ? AppStrings.active : AppStrings.passive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EditUserDialog extends StatefulWidget {
  final UserController controller;
  final ManagedUserEntity user;

  const _EditUserDialog({required this.controller, required this.user});

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _tcNoCtrl;
  late final TextEditingController _selectedCityCtrl;
  late final TextEditingController _profileImageCtrl;
  late final CompanyController _cc;
  late String _selectedRole;
  late String _selectedCompanyId;

  static const _editableRoles = {'customer': 'Müşteri', 'guide': 'Rehber', 'admin': 'Admin'};

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.user.fullName);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _tcNoCtrl = TextEditingController(text: widget.user.tcNo);
    _selectedCityCtrl = TextEditingController(text: widget.user.selectedCity);
    _profileImageCtrl = TextEditingController(text: widget.user.profileImage ?? '');
    _cc = Get.find<CompanyController>();
    _selectedRole = widget.user.role == 'super_admin' ? 'admin' : widget.user.role;
    _selectedCompanyId = widget.user.companyId;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _tcNoCtrl.dispose();
    _selectedCityCtrl.dispose();
    _profileImageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.editUser),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _readOnlyField('Giriş E-postası', widget.user.email),
              const SizedBox(height: 12),
              _editableField('Ad Soyad', _fullNameCtrl),
              const SizedBox(height: 12),
              _editableField('Telefon', _phoneCtrl),
              const SizedBox(height: 12),
              _editableField('TC No', _tcNoCtrl),
              const SizedBox(height: 12),
              _editableField('Seçili Şehir', _selectedCityCtrl),
              const SizedBox(height: 12),
              _editableField('Profil Görsel URL', _profileImageCtrl),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: _editableRoles.entries
                    .map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedRole = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCompanyId.isEmpty ? null : _selectedCompanyId,
                decoration: const InputDecoration(labelText: 'Şirket'),
                items: [
                  const DropdownMenuItem<String>(value: '', child: Text('Şirket atanmadı')),
                  ...[..._cc.activeCompanies, ..._cc.passiveCompanies].map(
                    (company) => DropdownMenuItem<String>(
                      value: company.id,
                      child: Text(company.companyName),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedCompanyId = value ?? ''),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
        FilledButton(
          onPressed: () async {
            // UserController.updateUser Map<String, dynamic> alacak sekilde guncellendi
            final data = <String, dynamic>{
              'fullName': _fullNameCtrl.text.trim(),
              'phone': _phoneCtrl.text.trim(),
              'role': _selectedRole,
              'companyId': _selectedCompanyId,
              'tcNo': _tcNoCtrl.text.trim(),
              'selectedCity': _selectedCityCtrl.text.trim(),
            };
            if (_profileImageCtrl.text.trim().isNotEmpty) {
              data['profileImage'] = _profileImageCtrl.text.trim();
            }
            await widget.controller.updateUser(widget.user.uid!, data);
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }

  Widget _editableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(labelText: label),
      enabled: false,
    );
  }
}
