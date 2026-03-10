import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/models/tour_completion_request_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../features/completion/presentation/controllers/completion_controller.dart';
import '../../../../features/notifications/presentation/controllers/notification_controller.dart';

/// Super Admin tarafindan gonderilen bildirimlerin listelenip okundu
/// olarak isaretlendigi ekran.
///
/// [NotificationController] uzerinden calisir; eski AdminNotificationController
/// referansi yoktur.
class AdminNotificationsScreen extends StatefulWidget {
  final String companyId;

  const AdminNotificationsScreen({super.key, required this.companyId});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  late final NotificationController _controller;
  late final CompletionController _completionController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<NotificationController>();
    _completionController = Get.find<CompletionController>();
    // Sirkete ait bildirimleri gercek zamanli izle
    _controller.watchNotifications(widget.companyId);
    _completionController.watchRequests(widget.companyId);
  }

  void _approveCompletion(TourCompletionRequestModel request) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Tur Bitirme Onayi',
        message:
            'Bu talebi onaylarsaniz ilgili tur serisi, rehber hesabi ve bu tura ait panel musterileri pasife alinacak.',
        onConfirm: () async {
          await _completionController.approve(
            requestId: request.id!,
            tourId: request.tourId,
            guideId: request.guideId,
          );
        },
      ),
    );
  }

  void _rejectCompletion(TourCompletionRequestModel request) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Tur Bitirme Reddi',
        message: 'Bu talebi reddetmek istediginize emin misiniz?',
        onConfirm: () => _completionController.reject(request.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          Obx(() {
            final unread = _controller.notifications.where((n) => !n.isRead).length;
            if (unread == 0) return const SizedBox.shrink();
            return TextButton.icon(
              icon: const Icon(Icons.done_all),
              label: Text('Tamamini oku ($unread)'),
              onPressed: () => _controller.markAllRead(widget.companyId),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.notifications_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  AppStrings.notifications,
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
              'Super Admin bildirimleri ve rehberlerden gelen tur bitirme talepleri.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final notifications = _controller.notifications;
                final completionRequests = _completionController.requests;
                if (notifications.isEmpty && completionRequests.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off, size: 48, color: AppColors.slate300),
                        SizedBox(height: 12),
                        Text(
                          'Bildirim bulunmuyor.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                return ListView(
                  children: [
                    if (completionRequests.isNotEmpty) ...[
                      const _SectionTitle(
                        title: 'Tur Bitirme Talepleri',
                        subtitle:
                            'Bildirim ekranina dusen rehber talepleri buradan da yonetilebilir.',
                      ),
                      const SizedBox(height: 8),
                      ...completionRequests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _CompletionRequestTile(
                            request: request,
                            onApprove: _approveCompletion,
                            onReject: _rejectCompletion,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (notifications.isNotEmpty) ...[
                      const _SectionTitle(
                        title: 'Genel Bildirimler',
                        subtitle: 'Super Admin tarafindan gonderilen bildirimler.',
                      ),
                      const SizedBox(height: 8),
                      ...notifications.map(
                        (notification) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _NotificationTile(
                            notification: notification,
                            onMarkRead: (id) => _controller.markRead(id),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _CompletionRequestTile extends StatelessWidget {
  final TourCompletionRequestModel request;
  final void Function(TourCompletionRequestModel) onApprove;
  final void Function(TourCompletionRequestModel) onReject;

  const _CompletionRequestTile({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = request.requestedAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(request.requestedAt!.toDate())
        : '';

    return Card(
      color: AppColors.warning.withAlpha(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.warning,
              child: Icon(Icons.flag_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.tourTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Talep zamani: $dateStr',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Onay seri tur tarihlerini ve bagli panel hesaplarini pasife alir.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => onReject(request),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text(AppStrings.reject),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => onApprove(request),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text(AppStrings.confirm),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek bir bildirimi gosteren liste kutucugu widget'i.
class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final void Function(String) onMarkRead;

  const _NotificationTile({required this.notification, required this.onMarkRead});

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final dateStr = n.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(n.createdAt!.toDate())
        : '';

    return Card(
      color: n.isRead ? null : AppColors.info.withAlpha(15),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: n.isRead ? AppColors.slate200 : AppColors.info,
          child: Icon(
            n.isRead ? Icons.mark_email_read : Icons.mail,
            color: n.isRead ? AppColors.slate500 : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          n.title,
          style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(n.body),
            const SizedBox(height: 4),
            Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        trailing: !n.isRead && n.id != null
            ? IconButton(
                tooltip: 'Okundu olarak isaaretle',
                icon: const Icon(Icons.done_all, color: AppColors.primary),
                onPressed: () => onMarkRead(n.id!),
              )
            : null,
      ),
    );
  }
}
