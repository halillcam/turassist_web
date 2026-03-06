import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../controllers/sa_feedback_controller.dart';

class SuperAdminFeedbackScreen extends StatelessWidget {
  const SuperAdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SAFeedbackController>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.feedback)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.feedback, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  AppStrings.feedback,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Şirket adminlerinden gelen geri bildirimler.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final list = ctrl.feedbacks;
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz geri bildirim bulunmuyor.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final fb = list[index];
                    final dateStr = fb.createdAt != null
                        ? DateFormat('dd.MM.yyyy HH:mm').format(fb.createdAt!.toDate())
                        : '-';
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.feedback, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fb.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        fb.description,
                                        style: const TextStyle(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Şirket + Admin bilgileri
                            Obx(() {
                              final companyName = ctrl.getCompanyName(fb.companyId);
                              final adminName = ctrl.getAdminName(fb.companyId);
                              final adminPhone = ctrl.getAdminPhone(fb.companyId);
                              return Wrap(
                                spacing: 24,
                                runSpacing: 8,
                                children: [
                                  _infoChip(Icons.business, 'Şirket', companyName),
                                  _infoChip(Icons.person, 'Admin', adminName),
                                  _infoChip(Icons.phone, 'Telefon', adminPhone),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.slate500),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
