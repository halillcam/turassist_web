import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../controllers/sa_notification_controller.dart';

class SuperAdminNotificationsScreen extends StatefulWidget {
  const SuperAdminNotificationsScreen({super.key});

  @override
  State<SuperAdminNotificationsScreen> createState() => _SuperAdminNotificationsScreenState();
}

class _SuperAdminNotificationsScreenState extends State<SuperAdminNotificationsScreen> {
  static const double _pagePadding = 24;
  static const double _sectionSpacing = 24;

  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  SANotificationController get _ctrl => Get.find<SANotificationController>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _handleSend() {
    _ctrl.sendNotification(title: _titleCtrl.text, body: _bodyCtrl.text).then((_) {
      _titleCtrl.clear();
      _bodyCtrl.clear();
    });
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  TextStyle _sectionTitleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  }

  TextStyle _sectionSubtitleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary, fontSize: 13);
  }

  Widget _buildComposerCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.send,
              title: AppStrings.sendNotification,
              subtitle: AppStrings.sendNotificationDescription,
              titleStyle: _sectionTitleStyle(context),
              subtitleStyle: _sectionSubtitleStyle(context),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final companies = _ctrl.companies;
              return DropdownButtonFormField<String?>(
                initialValue: _ctrl.selectedCompanyId.value,
                isExpanded: true,
                decoration: _inputDecoration(AppStrings.notificationTargetCompany),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(AppStrings.allActiveCompanies, overflow: TextOverflow.ellipsis),
                  ),
                  ...companies.map(
                    (company) => DropdownMenuItem<String?>(
                      value: company.id,
                      child: Text(company.companyName, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (value) => _ctrl.selectedCompanyId.value = value,
              );
            }),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleCtrl,
              decoration: _inputDecoration(AppStrings.notificationTitle),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyCtrl,
              maxLines: 4,
              decoration: _inputDecoration(AppStrings.notificationBody),
            ),
            const SizedBox(height: 20),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _ctrl.isLoading.value ? null : _handleSend,
                  icon: _ctrl.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _ctrl.isLoading.value
                        ? AppStrings.sendingNotification
                        : AppStrings.sendNotification,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.history,
              title: AppStrings.sentNotificationsTitle,
              titleStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final notifications = _ctrl.sentNotifications;
                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noNotificationsYet,
                      style: _sectionSubtitleStyle(context),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final dateText = notification.createdAt != null
                        ? DateFormat('dd.MM.yyyy HH:mm').format(notification.createdAt!.toDate())
                        : '-';

                    return _NotificationHistoryItem(
                      title: notification.title,
                      body: notification.body,
                      dateText: dateText,
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

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 1200;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
      body: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildComposerCard(context),
                  const SizedBox(height: _sectionSpacing),
                  Expanded(child: _buildHistoryCard(context)),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildComposerCard(context)),
                  const SizedBox(width: _sectionSpacing),
                  Expanded(flex: 3, child: _buildHistoryCard(context)),
                ],
              ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final TextStyle titleStyle;
  final TextStyle? subtitleStyle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: titleStyle),
            ),
          ],
        ),
        if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: subtitleStyle)],
      ],
    );
  }
}

class _NotificationHistoryItem extends StatelessWidget {
  final String title;
  final String body;
  final String dateText;

  const _NotificationHistoryItem({required this.title, required this.body, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        if (isCompact) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.notifications, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dateText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.notifications, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Text(
                  dateText,
                  textAlign: TextAlign.end,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
