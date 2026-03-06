import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../controllers/sa_user_controller.dart';

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
    final controller = Get.find<SAUserController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.userList)),
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
                      headingRowColor: WidgetStateProperty.all(AppColors.primary.withAlpha(20)),
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Ad Soyad')),
                        DataColumn(label: Text('E-posta')),
                        DataColumn(label: Text('Telefon')),
                        DataColumn(label: Text('Rol')),
                        DataColumn(label: Text('Şirket ID')),
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
                            DataCell(Text(u.companyId.isEmpty ? '-' : u.companyId)),
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

  Widget _buildFilters(SAUserController controller) {
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
          () => DropdownButton<String?>(
            value: controller.selectedRole.value,
            hint: const Text('Tüm Roller'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tüm Roller')),
              ..._roleLabels.entries.map(
                (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
              ),
            ],
            onChanged: (val) => controller.selectedRole.value = val,
          ),
        ),
      ],
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
}
