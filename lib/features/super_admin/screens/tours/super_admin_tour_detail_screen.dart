import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';

class SuperAdminTourDetailScreen extends StatefulWidget {
  final String tourId;

  const SuperAdminTourDetailScreen({super.key, required this.tourId});

  @override
  State<SuperAdminTourDetailScreen> createState() =>
      _SuperAdminTourDetailScreenState();
}

class _SuperAdminTourDetailScreenState
    extends State<SuperAdminTourDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTourDetail();
  }

  Future<void> _loadTourDetail() async {
    // TODO: Firestore'dan tur detayı çekilecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tourDetail)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tur Detayı (Super Admin)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Admin rolündeki tüm tur işlemleri burada yapılabilir.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tur Bilgileri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TODO: Tur bilgileri burada gösterilecek
                    const Text('Tur verileri yükleniyor...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CustomButton(
                  text: 'Katılımcıları Gör',
                  onPressed: () {},
                  icon: Icons.people,
                ),
                CustomButton(
                  text: AppStrings.addParticipant,
                  onPressed: () {},
                  icon: Icons.person_add,
                  backgroundColor: AppColors.success,
                ),
                CustomButton(
                  text: AppStrings.addGuide,
                  onPressed: () {},
                  icon: Icons.admin_panel_settings,
                  backgroundColor: AppColors.warning,
                ),
                CustomButton(
                  text: AppStrings.updateTour,
                  onPressed: () {},
                  icon: Icons.edit,
                  backgroundColor: AppColors.primaryLight,
                ),
                CustomButton(
                  text: AppStrings.delete,
                  onPressed: () {},
                  icon: Icons.delete,
                  backgroundColor: AppColors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
