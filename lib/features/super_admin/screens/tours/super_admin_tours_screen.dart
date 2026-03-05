import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class SuperAdminToursScreen extends StatefulWidget {
  const SuperAdminToursScreen({super.key});

  @override
  State<SuperAdminToursScreen> createState() => _SuperAdminToursScreenState();
}

class _SuperAdminToursScreenState extends State<SuperAdminToursScreen>
    with SingleTickerProviderStateMixin {
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
        title: const Text(AppStrings.tours),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktif Turlar'),
            Tab(text: 'Pasif Turlar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aktif turlar (şirketlere göre)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktif Turlar (Şirketlere Göre)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                // TODO: Şirketlere göre aktif turlar listesi
                // Tur ekle, sil, güncelle, katılımcı ekle vs işlemleri
                const Expanded(
                  child: Center(child: Text('Aktif turlar yükleniyor...')),
                ),
              ],
            ),
          ),
          // Pasif turlar (şirketlere göre)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pasif Turlar (Şirketlere Göre)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                // TODO: Şirketlere göre pasif turlar listesi
                const Expanded(
                  child: Center(child: Text('Pasif turlar yükleniyor...')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
