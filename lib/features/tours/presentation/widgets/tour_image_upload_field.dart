import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/tour_image_upload_service.dart';

class TourImageUploadField extends StatelessWidget {
  final bool isUploading;
  final TextEditingController imageUrlController;
  final String imageUrl;
  final String? uploadedImageFileName;
  final VoidCallback? onUploadPressed;
  final VoidCallback? onRemovePressed;

  const TourImageUploadField({
    super.key,
    required this.isUploading,
    required this.imageUrlController,
    required this.imageUrl,
    this.uploadedImageFileName,
    this.onUploadPressed,
    this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedImageUrl = imageUrl.trim();
    final hasImage = trimmedImageUrl.isNotEmpty;
    final uploadEnabled = TourImageUploadService.directUploadEnabled;
    final helperText = uploadEnabled
        ? (hasImage
              ? (uploadedImageFileName ?? 'Firebase Storage görseli hazır')
              : 'Dosya seçildiğinde görsel Firebase Storage alanına yüklenir ve turun imageUrl alanına kaydedilir.')
        : TourImageUploadService.directUploadDisabledReason;

    return SizedBox(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: isUploading || !uploadEnabled ? null : onUploadPressed,
            icon: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file),
            label: Text(isUploading ? 'Yükleniyor...' : 'Görsel Yükle'),
          ),
          const SizedBox(height: 8),
          Text(
            helperText,
            style: TextStyle(
              color: uploadEnabled ? AppColors.textSecondary : AppColors.warning,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: imageUrlController,
            decoration: InputDecoration(
              labelText: 'Görsel URL',
              hintText: 'https://.../gorsel.jpg',
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                trimmedImageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: const Text('Görsel önizlemesi alınamadı'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    trimmedImageUrl,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
                IconButton(
                  onPressed: isUploading ? null : onRemovePressed,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  tooltip: 'Görseli kaldır',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
