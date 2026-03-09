import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/tour_model.dart';
import '../../controllers/sa_tour_controller.dart';
import 'super_admin_tour_detail_screen.dart';

class SaTourScheduleScreen extends StatefulWidget {
  final String companyId;
  final String representativeTourId;
  final String? seriesId;
  final bool isDeleted;

  const SaTourScheduleScreen({
    super.key,
    required this.companyId,
    required this.representativeTourId,
    this.seriesId,
    required this.isDeleted,
  });

  @override
  State<SaTourScheduleScreen> createState() => _SaTourScheduleScreenState();
}

class _SaTourScheduleScreenState extends State<SaTourScheduleScreen> {
  late final SATourController _controller;

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
  void initState() {
    super.initState();
    _controller = Get.find<SATourController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tur Takvimi')),
      body: StreamBuilder<List<TourModel>>(
        stream: _controller.service.streamToursByCompany(
          widget.companyId,
          isDeleted: widget.isDeleted,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Takvim yüklenemedi: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final tours = snapshot.data ?? const <TourModel>[];
          final matchingTours = tours.where(_matchesSelection).toList();
          if (matchingTours.isEmpty) {
            return const Center(
              child: Text(
                'Bu ana tura ait takvim bulunamadı.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final group = _ResolvedTourGroup(
            tours: matchingTours,
            representativeTourId: widget.representativeTourId,
          );

          return LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              final summary = _TourSummaryCard(group: group);
              final schedule = _ScheduleList(
                group: group,
                onOpenDate: (date) => _openTourDetail(group.instanceForDate(date), date),
                onOpenWithoutDate: () => _openTourDetail(group.representative, null),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [summary, const SizedBox(height: 16), schedule],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: summary),
                          const SizedBox(width: 16),
                          Expanded(flex: 4, child: schedule),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  bool _matchesSelection(TourModel tour) {
    if (widget.seriesId != null && widget.seriesId!.isNotEmpty) {
      return tour.seriesId == widget.seriesId;
    }
    return tour.id == widget.representativeTourId;
  }

  void _openTourDetail(TourModel tour, DateTime? departureDate) {
    final tourId = tour.id;
    if (tourId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuperAdminTourDetailScreen(tourId: tourId, departureDate: departureDate),
      ),
    );
  }
}

class _ResolvedTourGroup {
  final List<TourModel> tours;
  final String representativeTourId;

  _ResolvedTourGroup({required this.tours, required this.representativeTourId}) {
    tours.sort((a, b) {
      final da = a.departureDate ?? DateTime(9999);
      final db = b.departureDate ?? DateTime(9999);
      return da.compareTo(db);
    });
  }

  TourModel get representative {
    for (final tour in tours) {
      if (tour.id == representativeTourId) return tour;
    }
    return tours.first;
  }

  List<DateTime> get allDates {
    final dates = <DateTime>{};
    for (final tour in tours) {
      if (tour.departureDate != null) {
        dates.add(_normalizeDate(tour.departureDate!));
      }
    }
    if (tours.length == 1) {
      for (final date in tours.first.departureDates ?? const <DateTime>[]) {
        dates.add(_normalizeDate(date));
      }
    }
    final result = dates.toList()..sort();
    return result;
  }

  TourModel instanceForDate(DateTime date) {
    if (tours.length == 1) return tours.first;
    final normalizedTarget = _normalizeDate(date);
    for (final tour in tours) {
      final departureDate = tour.departureDate;
      if (departureDate != null && _normalizeDate(departureDate) == normalizedTarget) {
        return tour;
      }
    }
    return representative;
  }

  static DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);
}

class _TourSummaryCard extends StatelessWidget {
  final _ResolvedTourGroup group;

  const _TourSummaryCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final tour = group.representative;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkSurface, AppColors.cardDark],
        ),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.primary.withAlpha(40)),
              ),
              child: const Text(
                'Ana Tur',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: tour.imageUrl.isNotEmpty
                      ? Image.network(
                          tour.imageUrl,
                          width: 184,
                          height: 128,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${tour.city} • ${tour.region}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _summaryChip(
                            Icons.payments_outlined,
                            '₺${tour.price.toStringAsFixed(0)}',
                          ),
                          _summaryChip(Icons.people_outline, '${tour.capacity} kişi'),
                          _summaryChip(Icons.schedule, tour.departureTime),
                          _summaryChip(Icons.event_note, '${group.allDates.length} takvim'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (tour.description.isNotEmpty) ...[
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlayDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  tour.description,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.55),
                ),
              ),
            ],
            if (tour.departureDays.isNotEmpty) ...[
              const SizedBox(height: 20),
              _infoItem(
                'Haftalık Günler',
                tour.departureDays
                    .map((day) => _SaTourScheduleScreenState._dayLabels[day] ?? '')
                    .join(', '),
              ),
            ],
            if (group.allDates.isNotEmpty) ...[
              const SizedBox(height: 22),
              const Text(
                'Kayıtlı Takvimler',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: group.allDates
                    .map(
                      (date) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOverlayDark,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Text(
                          dateFormat.format(date),
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _summaryChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlayDark,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(18),
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 13, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  static Widget _infoItem(String label, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlayDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
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
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  static Widget _placeholder() {
    return Container(
      width: 184,
      height: 128,
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlayDark,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 36, color: AppColors.slate400),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final _ResolvedTourGroup group;
  final ValueChanged<DateTime> onOpenDate;
  final VoidCallback onOpenWithoutDate;

  const _ScheduleList({
    required this.group,
    required this.onOpenDate,
    required this.onOpenWithoutDate,
  });

  @override
  Widget build(BuildContext context) {
    final dates = group.allDates;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Takvimler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bir tarih seçin. Seçtiğiniz takvime ait tur detayı açılır.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 18),
            if (dates.isEmpty)
              FilledButton.icon(
                onPressed: onOpenWithoutDate,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Tur Detayını Aç'),
              )
            else
              ...dates.map(
                (date) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ScheduleTile(
                    date: date,
                    instanceCount: group.tours.length,
                    onTap: () => onOpenDate(date),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final DateTime date;
  final int instanceCount;
  final VoidCallback onTap;

  const _ScheduleTile({required this.date, required this.instanceCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPast = date.isBefore(DateTime.now());
    final dateText = DateFormat('dd.MM.yyyy').format(date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          color: isPast ? AppColors.surfaceOverlayDark : AppColors.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: (isPast ? AppColors.slate400 : AppColors.primary).withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isPast ? Icons.history : Icons.event_available,
                  color: isPast ? AppColors.slate400 : AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instanceCount > 1
                          ? 'Bu tarihe bağlı tur instance detayı açılır.'
                          : 'Bu tarihte satın alınan biletler için detay açılır.',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isPast ? AppColors.slate400 : AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
