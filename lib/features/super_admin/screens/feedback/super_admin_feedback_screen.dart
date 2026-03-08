import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/feedback_model.dart';
import '../../controllers/sa_feedback_controller.dart';

class SuperAdminFeedbackScreen extends StatefulWidget {
  const SuperAdminFeedbackScreen({super.key});

  @override
  State<SuperAdminFeedbackScreen> createState() => _SuperAdminFeedbackScreenState();
}

class _SuperAdminFeedbackScreenState extends State<SuperAdminFeedbackScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SAFeedbackController>();
    final title = _selectedTab == 0 ? AppStrings.pendingFeedback : AppStrings.resolvedFeedback;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.feedback)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.feedback, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
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
            SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(value: 0, label: Text('Bekleyenler'), icon: Icon(Icons.pending)),
                ButtonSegment<int>(value: 1, label: Text('Çözülenler'), icon: Icon(Icons.task_alt)),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (selection) {
                setState(() => _selectedTab = selection.first);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final list = _selectedTab == 0 ? ctrl.pendingFeedbacks : ctrl.resolvedFeedbacks;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      _selectedTab == 0
                          ? 'Henüz bekleyen geri bildirim bulunmuyor.'
                          : 'Henüz çözülen geri bildirim bulunmuyor.',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final fb = list[index];
                    return _FeedbackCard(
                      feedback: fb,
                      companyName: ctrl.getCompanyName(fb.companyId),
                      adminName: ctrl.getAdminName(fb.companyId),
                      adminPhone: ctrl.getAdminPhone(fb.companyId),
                      onToggleResolved: () async {
                        await ctrl.setResolved(fb, isResolved: !fb.isResolved);
                        if (fb.isResolved) {
                          setState(() => _selectedTab = 0);
                        } else {
                          setState(() => _selectedTab = 1);
                        }
                      },
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
}

class _FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;
  final String companyName;
  final String adminName;
  final String adminPhone;
  final Future<void> Function() onToggleResolved;

  const _FeedbackCard({
    required this.feedback,
    required this.companyName,
    required this.adminName,
    required this.adminPhone,
    required this.onToggleResolved,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = feedback.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(feedback.createdAt!.toDate())
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
                CircleAvatar(
                  backgroundColor: feedback.isResolved ? AppColors.success : AppColors.primary,
                  child: const Icon(Icons.feedback, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              feedback.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _statusChip(feedback.isResolved),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feedback.description,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _infoChip(Icons.business, 'Şirket', companyName),
                _infoChip(Icons.person, 'Admin', adminName),
                _infoChip(Icons.phone, 'Telefon', adminPhone),
                if (feedback.isResolved && feedback.resolvedBy != null)
                  _infoChip(Icons.task_alt, 'Çözen', feedback.resolvedBy!),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onToggleResolved,
                icon: Icon(feedback.isResolved ? Icons.undo : Icons.task_alt),
                label: Text(
                  feedback.isResolved ? AppStrings.reopenFeedback : AppStrings.markResolved,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(bool isResolved) {
    final color = isResolved ? AppColors.success : AppColors.warning;
    final label = isResolved ? AppStrings.feedbackResolved : AppStrings.feedbackPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
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
