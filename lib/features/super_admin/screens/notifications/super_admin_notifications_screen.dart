import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class SuperAdminNotificationsScreen extends StatefulWidget {
  const SuperAdminNotificationsScreen({super.key});

  @override
  State<SuperAdminNotificationsScreen> createState() =>
      _SuperAdminNotificationsScreenState();
}

class _SuperAdminNotificationsScreenState
    extends State<SuperAdminNotificationsScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _handleSendNotification() async {
    setState(() => _isLoading = true);
    // TODO: Aktif şirketlere push notification gönderilecek
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.sendNotification,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aktif şirketlere bildirim gönderin.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Bildirim Başlığı',
                      controller: _titleController,
                    ),
                    CustomTextField(
                      label: 'Bildirim İçeriği',
                      controller: _bodyController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    // TODO: Şirket seçimi dropdown eklenecek
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        text: 'Bildirim Gönder',
                        onPressed: _handleSendNotification,
                        isLoading: _isLoading,
                        icon: Icons.send,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
