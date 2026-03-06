import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/notification_model.dart';
import '../../services/admin_tour_service.dart';

class AdminNotificationsScreen extends StatefulWidget {
  final String companyId;

  const AdminNotificationsScreen({super.key, required this.companyId});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _service = AdminTourService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
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
              'Super Admin tarafından gönderilen bildirimler.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<NotificationModel>>(
                stream: _service.streamNotifications(widget.companyId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final notifications = snapshot.data!;
                  if (notifications.isEmpty) {
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
                  return ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _notificationTile(notifications[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationModel n) {
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
        trailing: !n.isRead
            ? IconButton(
                tooltip: 'Okundu olarak işaretle',
                icon: const Icon(Icons.done_all, color: AppColors.primary),
                onPressed: () {
                  if (n.id != null) {
                    _service.markNotificationAsRead(n.id!);
                  }
                },
              )
            : null,
      ),
    );
  }
}
