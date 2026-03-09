import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/tour_model.dart';
import '../../controllers/admin_tour_controller.dart';
import 'tour_schedule_screen.dart';

class ActiveToursScreen extends StatefulWidget {
  final String companyId;

  const ActiveToursScreen({super.key, required this.companyId});

  @override
  State<ActiveToursScreen> createState() => _ActiveToursScreenState();
}

class _ActiveToursScreenState extends State<ActiveToursScreen> {
  late final AdminTourController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminTourController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.activeTours)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tour, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.activeTours,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<TourModel>>(
                stream: _controller.streamActiveTours(widget.companyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Hata: ${snapshot.error}',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }
                  final tours = snapshot.data ?? [];
                  if (tours.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tour, size: 64, color: AppColors.slate300),
                          SizedBox(height: 16),
                          Text(
                            'Aktif tur bulunmuyor.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  final groups = _groupTours(tours);
                  return _TourGroupListView(groups: groups);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Turları seriesId'ye göre gruplar.
  static List<_TourGroup> _groupTours(List<TourModel> tours) {
    final Map<String, List<TourModel>> bySeriesId = {};
    final List<TourModel> standalone = [];

    for (final tour in tours) {
      if (tour.seriesId != null && tour.seriesId!.isNotEmpty) {
        bySeriesId.putIfAbsent(tour.seriesId!, () => []).add(tour);
      } else {
        standalone.add(tour);
      }
    }

    final groups = <_TourGroup>[];

    for (final instances in bySeriesId.values) {
      instances.sort((a, b) {
        final da = a.departureDate ?? DateTime(9999);
        final db = b.departureDate ?? DateTime(9999);
        return da.compareTo(db);
      });
      groups.add(_TourGroup(instances: instances));
    }

    for (final tour in standalone) {
      groups.add(_TourGroup(instances: [tour]));
    }

    groups.sort(
      (a, b) => (b.representative.createdAt ?? DateTime(0)).compareTo(
        a.representative.createdAt ?? DateTime(0),
      ),
    );

    return groups;
  }
}

class _TourGroup {
  final List<TourModel> instances;

  _TourGroup({required this.instances});

  TourModel get representative => instances.first;

  List<DateTime> get allDates {
    final dates = <DateTime>{};
    for (final t in instances) {
      if (t.departureDate != null) dates.add(t.departureDate!);
    }
    if (instances.length == 1) {
      for (final d in instances.first.departureDates ?? []) {
        dates.add(d);
      }
    }
    return dates.toList()..sort();
  }

  bool get hasMultipleDates => allDates.length > 1;

  TourModel instanceForDate(DateTime date) {
    if (instances.length == 1) return instances.first;
    return instances.firstWhere(
      (t) =>
          t.departureDate != null &&
          t.departureDate!.year == date.year &&
          t.departureDate!.month == date.month &&
          t.departureDate!.day == date.day,
      orElse: () => instances.first,
    );
  }
}

class _TourGroupListView extends StatelessWidget {
  final List<_TourGroup> groups;

  const _TourGroupListView({required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) => _TourGroupCard(group: groups[index]),
    );
  }
}

class _TourGroupCard extends StatelessWidget {
  final _TourGroup group;

  const _TourGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final tour = group.representative;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dates = group.allDates;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: tour.imageUrl.isNotEmpty
                    ? Image.network(
                        tour.imageUrl,
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tour.city} • ${tour.region}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    if (dates.isNotEmpty)
                      _datesRow(dates, dateFormat)
                    else
                      _departureDaysChip(tour),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₺${tour.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kapasite: ${tour.capacity}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  if (group.instances.length > 1) ...[
                    const SizedBox(height: 4),
                    _chip(AppColors.info, '${group.instances.length} tarih'),
                  ],
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                group.hasMultipleDates ? Icons.calendar_month : Icons.chevron_right,
                color: AppColors.slate400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datesRow(List<DateTime> dates, DateFormat fmt) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...dates
            .take(4)
            .map(
              (d) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  fmt.format(d),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        if (dates.length > 4)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.slate200,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '+${dates.length - 4} daha',
              style: const TextStyle(color: AppColors.slate600, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final representative = group.representative;
    final tourId = representative.id;
    if (tourId == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tur bilgisi eksik olduğu için takvim açılamadı.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TourScheduleScreen(
          companyId: representative.companyId,
          representativeTourId: tourId,
          seriesId: representative.seriesId,
        ),
      ),
    );
  }

  static Widget _imagePlaceholder() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.image, color: AppColors.slate400),
    );
  }

  static const _dayLabels = {1: 'Pzt', 2: 'Sal', 3: 'Çar', 4: 'Per', 5: 'Cum', 6: 'Cmt', 7: 'Paz'};

  static Widget _departureDaysChip(TourModel tour) {
    if (tour.departureDays.isEmpty) return const SizedBox.shrink();
    final label = tour.departureDays.map((d) => _dayLabels[d] ?? '').join(', ');
    return _chip(AppColors.info, label);
  }

  static Widget _chip(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
