import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class SuperAdminFeedbackScreen extends StatefulWidget {
  const SuperAdminFeedbackScreen({super.key});

  @override
  State<SuperAdminFeedbackScreen> createState() =>
      _SuperAdminFeedbackScreenState();
}

class _SuperAdminFeedbackScreenState extends State<SuperAdminFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.feedback)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.feedback,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Şirket adminlerinden gelen geri bildirimler.\n'
              'Şirket ID, feedback başlığı, açıklaması, admin telefon no ve ad soyad görüntülenir.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      // TODO: Feedbackler Firestore stream ile listelenecek
                      // Her feedback için: şirket ID, başlık, açıklama, admin tel, ad soyad
                      Center(child: Text('Geri bildirimler yükleniyor...')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
