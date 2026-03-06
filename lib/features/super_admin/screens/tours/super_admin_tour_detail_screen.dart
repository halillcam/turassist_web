import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/tour_model.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../controllers/sa_tour_controller.dart';
import '../../services/super_admin_service.dart';

class SuperAdminTourDetailScreen extends StatefulWidget {
  final String tourId;

  const SuperAdminTourDetailScreen({super.key, required this.tourId});

  @override
  State<SuperAdminTourDetailScreen> createState() => _SuperAdminTourDetailScreenState();
}

class _SuperAdminTourDetailScreenState extends State<SuperAdminTourDetailScreen> {
  final _service = SuperAdminService();

  static const _dayLabels = {
    1: 'Pazartesi',
    2: 'Salı',
    3: 'Çarşamba',
    4: 'Perşembe',
    5: 'Cuma',
    6: 'Cumartesi',
    7: 'Pazar',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tourDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<TourModel?>(
        stream: _service.streamTour(widget.tourId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tour = snapshot.data;
          if (tour == null) {
            return const Center(
              child: Text('Tur bulunamadı.', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionButtons(tour),
                const SizedBox(height: 24),
                _buildInfoCard(tour),
                const SizedBox(height: 16),
                _buildBusInfoCard(tour),
                const SizedBox(height: 16),
                _buildDepartureCard(tour),
                if (tour.program.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildProgramCard(tour),
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(TourModel tour) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _actionButton(
          AppStrings.participants,
          Icons.people,
          AppColors.primary,
          () => Navigator.pushNamed(context, AppRoutes.saParticipantsList, arguments: tour.id),
        ),
        _actionButton(
          AppStrings.addParticipant,
          Icons.person_add,
          AppColors.success,
          () => Navigator.pushNamed(
            context,
            AppRoutes.saAddParticipant,
            arguments: {'tourId': tour.id ?? '', 'companyId': tour.companyId},
          ),
        ),
        _actionButton(
          AppStrings.addGuide,
          Icons.admin_panel_settings,
          AppColors.warning,
          () => Navigator.pushNamed(
            context,
            AppRoutes.saAddGuide,
            arguments: {'tourId': tour.id ?? '', 'companyId': tour.companyId},
          ),
        ),
        _actionButton(
          AppStrings.updateTour,
          Icons.edit,
          AppColors.primaryLight,
          () => Navigator.pushNamed(context, AppRoutes.saUpdateTour, arguments: tour.id),
        ),
        _actionButton(AppStrings.delete, Icons.delete, AppColors.error, () => _confirmDelete(tour)),
      ],
    );
  }

  Widget _actionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _confirmDelete(TourModel tour) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Turu Sil',
        message: '"${tour.title}" turunu silmek istediğinize emin misiniz?',
        confirmText: 'Sil',
        onConfirm: () async {
          try {
            final controller = Get.find<SATourController>();
            await controller.deleteTour(tour.id!);
            if (mounted) Navigator.pop(context);
          } catch (e) {
            Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(TourModel tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Tur Bilgileri'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                _infoItem('Başlık', tour.title),
                _infoItem('Fiyat', '₺${tour.price.toStringAsFixed(0)}'),
                _infoItem('Kapasite', '${tour.capacity}'),
                _infoItem('Şehir', tour.city),
                _infoItem('Bölge', tour.region),
                _infoItem('Rehber', tour.guideName ?? '-'),
                _infoItem('Durum', tour.isDeleted ? 'Pasif' : 'Aktif'),
              ],
            ),
            if (tour.description.isNotEmpty) ...[
              const Divider(height: 32),
              _infoItem('Açıklama', tour.description),
            ],
            if (tour.extraDetail.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem('Ekstra Detay', tour.extraDetail),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusInfoCard(TourModel tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Araç Bilgileri'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                _infoItem('Şoför Adı', tour.busInfo.driverName),
                _infoItem('Telefon', tour.busInfo.phoneNumber),
                _infoItem('Plaka', tour.busInfo.plate),
                _infoItem('Araç Kapasitesi', '${tour.busInfo.capacity}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureCard(TourModel tour) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Çıkış Bilgileri'),
            const SizedBox(height: 16),
            _infoItem('Çıkış Saati', tour.departureTime),
            if (tour.departureDays.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem(
                'Haftalık Çıkış Günleri',
                tour.departureDays.map((d) => _dayLabels[d] ?? '').join(', '),
              ),
            ],
            if (tour.departureDate != null) ...[
              const SizedBox(height: 8),
              _infoItem('Çıkış Tarihi', dateFormat.format(tour.departureDate!)),
            ],
            if (tour.departureDates != null && tour.departureDates!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem(
                'Özel Çıkış Tarihleri',
                tour.departureDates!.map((d) => dateFormat.format(d)).join(', '),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard(TourModel tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Tur Programı'),
            const SizedBox(height: 16),
            for (final day in tour.program) ...[
              Text(day.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              for (final act in day.activities)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                      Expanded(child: Text(act)),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      ],
    );
  }
}
