import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
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
              AppStrings.tourDetail,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Tur bilgileri kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tur Bilgileri',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // TODO: Tur bilgileri burada gösterilecek
                    const Text('Tur verileri yükleniyor...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Aksiyon butonları
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CustomButton(
                  text: AppStrings.participants,
                  onPressed: () {
                    // TODO: Katılımcıları gör
                  },
                  icon: Icons.people,
                ),
                CustomButton(
                  text: AppStrings.addParticipant,
                  onPressed: () {
                    // TODO: Katılımcı ekle
                  },
                  icon: Icons.person_add,
                  backgroundColor: AppColors.success,
                ),
                CustomButton(
                  text: AppStrings.addGuide,
                  onPressed: () {
                    // TODO: Tur sorumlusu ekle
                  },
                  icon: Icons.admin_panel_settings,
                  backgroundColor: AppColors.warning,
                ),
                CustomButton(
                  text: AppStrings.updateTour,
                  onPressed: () {
                    // TODO: Tur güncelleme ekranına git
                  },
                  icon: Icons.edit,
                  backgroundColor: AppColors.primaryLight,
                ),
                CustomButton(
                  text: AppStrings.delete,
                  onPressed: () {
                    // TODO: Turu sil
                  },
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
