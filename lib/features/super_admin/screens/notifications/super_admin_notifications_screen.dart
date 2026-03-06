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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Sol panel: bildirim gönder ───
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.send, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            AppStrings.sendNotification,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Belirli şirkete veya tüm aktif şirketlere bildirim gönderin.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      // Şirket seçimi
                      Obx(() {
                        final companies = _ctrl.companies;
                        return DropdownButtonFormField<String?>(
                          initialValue: _ctrl.selectedCompanyId.value,
                          decoration: InputDecoration(
                            labelText: 'Hedef Şirket',
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Tüm Aktif Şirketler'),
                            ),
                            ...companies.map(
                              (c) => DropdownMenuItem<String?>(
                                value: c.id,
                                child: Text(c.companyName),
                              ),
                            ),
                          ],
                          onChanged: (val) => _ctrl.selectedCompanyId.value = val,
                        );
                      }),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: InputDecoration(
                          labelText: 'Bildirim Başlığı',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _bodyCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Bildirim İçeriği',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(
                              _ctrl.isLoading.value ? 'Gönderiliyor...' : 'Bildirim Gönder',
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
              ),
            ),
            const SizedBox(width: 24),
            // ─── Sağ panel: gönderilen bildirimler listesi ───
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Gönderilen Bildirimler',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Obx(() {
                          final list = _ctrl.sentNotifications;
                          if (list.isEmpty) {
                            return const Center(
                              child: Text(
                                'Henüz bildirim gönderilmedi.',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final n = list[index];
                              final dateStr = n.createdAt != null
                                  ? DateFormat('dd.MM.yyyy HH:mm').format(n.createdAt!.toDate())
                                  : '-';
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.notifications, color: Colors.white, size: 18),
                                ),
                                title: Text(
                                  n.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  n.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  dateStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
