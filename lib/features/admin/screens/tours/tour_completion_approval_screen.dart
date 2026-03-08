import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/tour_completion_request_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../controllers/admin_completion_controller.dart';

class TourCompletionApprovalScreen extends StatefulWidget {
  final String companyId;

  const TourCompletionApprovalScreen({super.key, required this.companyId});

  @override
  State<TourCompletionApprovalScreen> createState() => _TourCompletionApprovalScreenState();
}

class _TourCompletionApprovalScreenState extends State<TourCompletionApprovalScreen> {
  late final AdminCompletionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminCompletionController>();
  }

  void _approve(TourCompletionRequestModel req) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Tur Bitirme Onayı',
        message:
            'Bu turu bitirmek istediğinize emin misiniz?\nTur pasif hale geçecek ve rehber silinecektir.',
        onConfirm: () async {
          try {
            await _controller.approveTourCompletion(
              requestId: req.id!,
              tourId: req.tourId,
              guideId: req.guideId,
            );
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tur bitirme onaylandı.'),
                backgroundColor: AppColors.success,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.error));
          }
        },
      ),
    );
  }

  void _reject(TourCompletionRequestModel req) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Tur Bitirme Reddi',
        message: 'Bu talebi reddetmek istediğinize emin misiniz?',
        onConfirm: () async {
          try {
            await _controller.rejectTourCompletion(req.id!);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Talep reddedildi.'),
                backgroundColor: AppColors.warning,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: AppColors.error));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tourCompletionApproval)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle_outline, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  AppStrings.tourCompletionApproval,
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
              'Tur sorumlusunun gönderdiği tur bitirme istekleri.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<TourCompletionRequestModel>>(
                stream: _controller.streamCompletionRequests(widget.companyId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final requests = snapshot.data!;
                  if (requests.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 48, color: AppColors.slate300),
                          SizedBox(height: 12),
                          Text(
                            'Bekleyen istek bulunmuyor.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: requests.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _requestCard(requests[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard(TourCompletionRequestModel req) {
    final dateStr = req.requestedAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(req.requestedAt!.toDate())
        : '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.warning,
              child: Icon(Icons.access_time, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req.tourTitle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Talep: $dateStr',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => _reject(req),
              icon: const Icon(Icons.close, size: 18),
              label: const Text(AppStrings.reject),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _approve(req),
              icon: const Icon(Icons.check, size: 18),
              label: const Text(AppStrings.confirm),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
