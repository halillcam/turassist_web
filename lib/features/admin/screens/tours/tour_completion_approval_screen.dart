import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/tour_completion_request_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../features/completion/presentation/controllers/completion_controller.dart';

/// Rehberin gonderdigi tur tamamlama taleplerinin listelenip
/// onaylandi / reddedildigi ekran.
///
/// [CompletionController] uzerinden calisir; eski AdminCompletionController
/// referansi yoktur.
class TourCompletionApprovalScreen extends StatefulWidget {
  final String companyId;

  const TourCompletionApprovalScreen({super.key, required this.companyId});

  @override
  State<TourCompletionApprovalScreen> createState() => _TourCompletionApprovalScreenState();
}

class _TourCompletionApprovalScreenState extends State<TourCompletionApprovalScreen> {
  late final CompletionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CompletionController>();
    // Sirkete ait tamamlama taleplerini gercek zamanli izle
    _controller.watchRequests(widget.companyId);
  }

  void _approve(TourCompletionRequestModel req) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Tur Bitirme Onayi',
        message:
            'Bu turu bitirmek istediginize emin misiniz?\nSeriye bagli tum tur tarihleri pasife alinacak, ilgili rehber ve bu tura ait panel musterileri devre disi birakilacaktir.',
        onConfirm: () async {
          try {
            await _controller.approve(requestId: req.id!, tourId: req.tourId, guideId: req.guideId);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tur bitirme onaylandi.'),
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
        message: 'Bu talebi reddetmek istediginize emin misiniz?',
        onConfirm: () async {
          try {
            await _controller.reject(req.id!);
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
              'Tur sorumlusunun gonderdigi tur bitirme istekleri. Onay, ilgili seri ve bagli panel hesaplarini da pasife alir.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final requests = _controller.requests;
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
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _RequestCard(
                    request: requests[index],
                    onApprove: _approve,
                    onReject: _reject,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek bir tamamlama talebini gosteren kart widget'i.
class _RequestCard extends StatelessWidget {
  final TourCompletionRequestModel request;
  final void Function(TourCompletionRequestModel) onApprove;
  final void Function(TourCompletionRequestModel) onReject;

  const _RequestCard({required this.request, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final dateStr = request.requestedAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(request.requestedAt!.toDate())
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
                    request.tourTitle,
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
              onPressed: () => onReject(request),
              icon: const Icon(Icons.close, size: 18),
              label: const Text(AppStrings.reject),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => onApprove(request),
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
