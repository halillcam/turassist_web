import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

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
          // Aktif şirketler
          Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Aktif Şirketler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    // TODO: Aktif şirketler listesi
                    Center(child: Text('Aktif şirketler yükleniyor...')),
                  ],
                ),
              ),
            ),
          ),
          // Pasif şirketler
          Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pasif Şirketler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    // TODO: Pasif şirketler listesi
                    Center(child: Text('Pasif şirketler yükleniyor...')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
