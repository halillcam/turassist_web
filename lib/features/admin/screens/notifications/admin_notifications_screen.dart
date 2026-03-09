import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/notification_model.dart';
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
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<NotificationController>();
    // Sirkete ait bildirimleri gercek zamanli izle
    _controller.watchNotifications(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          Obx(() {
            final unread =
                _controller.notifications.where((n) => !n.isRead).length;
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
              'Super Admin tarafindan gonderilen bildirimler.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final notifications = _controller.notifications;
                if (notifications.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off,
                            size: 48, color: AppColors.slate300),
                        SizedBox(height: 12),
                        Text(
                          'Bildirim bulunmuyor.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _NotificationTile(
                        notification: notifications[index],
                        onMarkRead: (id) => _controller.markRead(id),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          style: TextStyle(
              fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(n.body),
            const SizedBox(height: 4),
            Text(dateStr,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
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