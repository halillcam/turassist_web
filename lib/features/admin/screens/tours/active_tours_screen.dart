import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/tours/domain/entities/tour_entity.dart';
import '../../../../features/tours/presentation/controllers/tour_controller.dart';

/// Aktif turlarin seriye gore gruplandirilarak listeli ekrani.
/// [TourController.activeTours] [Obx] ile izlenir.
class ActiveToursScreen extends StatefulWidget {
  final String companyId;
  const ActiveToursScreen({super.key, required this.companyId});
  @override
  State<ActiveToursScreen> createState() => _ActiveToursScreenState();
}

class _ActiveToursScreenState extends State<ActiveToursScreen> {
  late final TourController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TourController>();
    _controller.loadActiveTours(widget.companyId);
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
              children: const [
                Icon(Icons.tour, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
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
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tours = _controller.activeTours;
                if (tours.isEmpty) return const _EmptyTours();
                return _TourGroupListView(groups: _groupTours(tours));
              }),
            ),
          ],
        ),
      ),
    );
  }

  static List<_TourGroup> _groupTours(List<TourEntity> tours) {
    final Map<String, List<TourEntity>> bySeries = {};
    final List<TourEntity> standalone = [];
    for (final tour in tours) {
      if (tour.seriesId != null && tour.seriesId!.isNotEmpty) {
        bySeries.putIfAbsent(tour.seriesId!, () => []).add(tour);
      } else {
        standalone.add(tour);
      }
    }
    final groups = <_TourGroup>[];
    for (final instances in bySeries.values) {
      instances.sort(
        (a, b) => (a.departureDate ?? DateTime(9999)).compareTo(b.departureDate ?? DateTime(9999)),
      );
      groups.add(_TourGroup(instances: instances));
    }
    for (final t in standalone) {
      groups.add(_TourGroup(instances: [t]));
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
  final List<TourEntity> instances;
  _TourGroup({required this.instances});
  TourEntity get representative => instances.first;
  List<DateTime> get allDates {
    final dates = <DateTime>{};
    for (final t in instances) {
      if (t.departureDate != null) {
        dates.add(t.departureDate!);
      }
    }
    if (instances.length == 1) {
      for (final d in instances.first.departureDates ?? []) {
        dates.add(d);
      }
    }
    return dates.toList()..sort();
  }

  bool get hasMultipleDates => allDates.length > 1;
}

class _EmptyTours extends StatelessWidget {
  const _EmptyTours();
  @override
  Widget build(BuildContext context) => const Center(
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

class _TourGroupListView extends StatelessWidget {
  final List<_TourGroup> groups;
  const _TourGroupListView({required this.groups});
  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: groups.length,
    itemBuilder: (ctx, i) => _TourGroupCard(group: groups[i]),
  );
}

class _TourGroupCard extends StatelessWidget {
  final _TourGroup group;
  const _TourGroupCard({required this.group});

  void _handleTap(BuildContext context) {
    final rep = group.representative;
    Navigator.pushNamed(
      context,
      AppRoutes.toursSchedule,
      arguments: {
        'companyId': rep.companyId,
        'representativeTourId': rep.id,
        'seriesId': rep.seriesId,
        'isDeleted': false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = group.representative;
    final fmt = DateFormat('dd.MM.yyyy');
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
                        errorBuilder: (context, error, stackTrace) => _placeholder(),
                      )
                    : _placeholder(),
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
                      '${tour.city} - ${tour.region}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    if (dates.isNotEmpty) _DatesRow(dates: dates, fmt: fmt),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${tour.price.toStringAsFixed(0)} TL',
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
                    _SmallChip(color: AppColors.info, label: '${group.instances.length} tarih'),
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

  Widget _placeholder() => Container(
    width: 80,
    height: 60,
    color: AppColors.slate100,
    child: const Icon(Icons.image, color: AppColors.slate400),
  );
}

class _DatesRow extends StatelessWidget {
  final List<DateTime> dates;
  final DateFormat fmt;
  const _DatesRow({required this.dates, required this.fmt});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      ...dates.take(4).map((d) => _SmallChip(color: AppColors.primary, label: fmt.format(d))),
      if (dates.length > 4)
        _SmallChip(color: AppColors.slate500, label: '+${dates.length - 4} daha'),
    ],
  );
}

class _SmallChip extends StatelessWidget {
  final Color color;
  final String label;
  const _SmallChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(999)),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
    ),
  );
}
