import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../companies/presentation/controllers/company_controller.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.companyList),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktif Şirketler'),
            Tab(text: 'Pasif Şirketler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => _CompanyTab(
              label: 'Aktif Şirketler',
              companies: controller.activeCompanies.toList(),
              emptyText: 'Aktif şirket bulunmuyor.',
            ),
          ),
          Obx(
            () => _CompanyTab(
              label: 'Pasif Şirketler',
              companies: controller.passiveCompanies.toList(),
              emptyText: 'Pasif şirket bulunmuyor.',
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyTab extends StatelessWidget {
  final String label;
  final List<CompanyEntity> companies;
  final String emptyText;

  const _CompanyTab({required this.label, required this.companies, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.business, size: 64, color: AppColors.slate300),
            const SizedBox(height: 16),
            Text(emptyText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: company.status ? AppColors.success : AppColors.slate400,
              child: const Icon(Icons.business, color: Colors.white),
            ),
            title: Text(company.companyName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Telefon: ${company.contactPhone}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                if (company.city.isNotEmpty)
                  Text(
                    'Şehir: ${company.city}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (company.status ? AppColors.success : AppColors.slate400).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    company.status ? 'Aktif' : 'Pasif',
                    style: TextStyle(
                      color: company.status ? AppColors.success : AppColors.slate400,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.slate400),
              ],
            ),
            onTap: () {
              if (company.id != null) {
                Navigator.pushNamed(context, AppRoutes.updateCompany, arguments: company.id);
              }
            },
          ),
        );
      },
    );
  }
}
