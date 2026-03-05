import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class TourCompletionApprovalScreen extends StatefulWidget {
  const TourCompletionApprovalScreen({super.key});

  @override
  State<TourCompletionApprovalScreen> createState() => _TourCompletionApprovalScreenState();
}

class _TourCompletionApprovalScreenState extends State<TourCompletionApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tourCompletionApproval)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.tourCompletionApproval,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tur sorumlusunun gönderdiği tur bitirme istekleri burada görünür.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // TODO: Tur bitirme istekleri stream ile listelenecek
                      // Her istek için Onayla/Reddet butonları olacak
                      const Center(child: Text('Bekleyen tur bitirme istekleri yükleniyor...')),
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
