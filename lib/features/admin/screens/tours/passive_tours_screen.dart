import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class PassiveToursScreen extends StatefulWidget {
  const PassiveToursScreen({super.key});

  @override
  State<PassiveToursScreen> createState() => _PassiveToursScreenState();
}

class _PassiveToursScreenState extends State<PassiveToursScreen>
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
        title: const Text(AppStrings.passiveTours),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Geçmiş Turlar'),
            Tab(text: 'Gelecek Turlar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Geçmiş turlar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Geçmiş Turlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    // TODO: Geçmiş pasif turlar listesi
                    Center(child: Text('Geçmiş turlar yükleniyor...')),
                  ],
                ),
              ),
            ),
          ),
          // Gelecek turlar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Gelecek Turlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    // TODO: Gelecek pasif turlar listesi
                    Center(child: Text('Gelecek turlar yükleniyor...')),
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
