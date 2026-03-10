import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class GuideCredentialsDialog extends StatelessWidget {
  final String guideId;
  final String password;

  const GuideCredentialsDialog({
    super.key,
    required this.guideId,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tur sorumlusu oluşturuldu'),
      content: SelectionArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aşağıdaki giriş bilgilerini tur sorumlusuna iletin.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _CredentialItem(label: 'Guide ID', value: guideId),
            const SizedBox(height: 12),
            _CredentialItem(label: 'Şifre', value: password),
          ],
        ),
      ),
      actions: [
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam')),
      ],
    );
  }
}

class _CredentialItem extends StatelessWidget {
  final String label;
  final String value;

  const _CredentialItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: SelectableText(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}