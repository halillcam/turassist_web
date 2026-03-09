import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/models/company_model.dart';
import '../../domain/entities/tour_entity.dart';
import '../controllers/tour_controller.dart';
import 'tour_schedule_screen.dart';

class ToursListScreen extends StatefulWidget {
  /// Admin flow: companyId geçilir, dropdown gösterilmez.
  /// SA flow: null geçilir, şirket dropdown'u gözükür.
  final String? companyId;

  const ToursListScreen({super.key, this.companyId});

  @override
  State<ToursListScreen> createState() => _ToursListScreenState();
}

class _ToursListScreenState extends State<ToursListScreen> with SingleTickerProviderStateMixin {
  late final TourController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TourController>();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.companyId != null) {
      // Admin flow: companyId dışarıdan verildi
      _controller.loadActiveTours(widget.companyId!);
      _controller.loadDeletedTours(widget.companyId!);
    } else {
      // SA flow: şirket listesini yükle
      _controller.loadCompanies();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turlar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktif Turlar'),
            Tab(text: 'Pasif Turlar'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (widget.companyId == null) _buildCompanySelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Obx(
                  () => _buildTourList(_controller.activeTours.toList(), 'Aktif tur bulunmuyor.'),
                ),
                Obx(
                  () => _buildTourList(_controller.deletedTours.toList(), 'Pasif tur bulunmuyor.'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildCompanySelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Obx(() {
        final companies = _controller.companies;
        final selected = _controller.selectedCompanyId.value;
        return Row(
          children: [
            const Icon(Icons.business, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Şirket: ',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selected,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Şirket seçin'),
                items: companies
                    .map(
                      (CompanyModel c) => DropdownMenuItem(value: c.id, child: Text(c.companyName)),
                    )
                    .toList(),
                onChanged: (val) => _controller.selectCompany(val),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFab() {
    return Obx(() {
      final companyId = widget.companyId ?? _controller.selectedCompanyId.value;
      if (companyId == null) return const SizedBox.shrink();
      return FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.toursAdd, arguments: companyId),
        icon: const Icon(Icons.add),
        label: const Text('Tur Ekle'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      );
    });
  }

  Widget _buildTourList(List<TourEntity> tours, String emptyText) {
    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tour, size: 64, color: AppColors.slate300),
            const SizedBox(height: 16),
            Text(emptyText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }
    final groups = _groupTours(tours);
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: groups.length,
      itemBuilder: (context, index) =>
          _TourCard(group: groups[index], onTap: (group) => _handleTap(group)),
    );
  }

  void _handleTap(_TourGroup group) {
    final tour = group.representative;
    final companyId = widget.companyId ?? _controller.selectedCompanyId.value ?? tour.companyId;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TourScheduleScreen(
          companyId: companyId,
          representativeTourId: tour.id,
          seriesId: tour.seriesId,
          isDeleted: tour.isDeleted,
        ),
      ),
    );
  }

  static List<_TourGroup> _groupTours(List<TourEntity> tours) {
    final Map<String, List<TourEntity>> bySeriesId = {};
    final List<TourEntity> standalone = [];

    for (final tour in tours) {
      final sid = tour.seriesId;
      if (sid != null && sid.isNotEmpty) {
        bySeriesId.putIfAbsent(sid, () => []).add(tour);
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

// ─── Domain grouping model ─────────────────────────────────────────────────

class _TourGroup {
  final List<TourEntity> instances;

  _TourGroup({required this.instances});

  TourEntity get representative => instances.first;

  List<DateTime> get allDates {
    final dates = <DateTime>{};
    for (final instance in instances) {
      if (instance.departureDate != null) dates.add(instance.departureDate!);
    }
    if (instances.length == 1) {
      for (final date in instances.first.departureDates ?? const <DateTime>[]) {
        dates.add(date);
      }
    }
    return dates.toList()..sort();
  }

  bool get hasMultipleDates => allDates.length > 1;
}

// ─── Tour Card ─────────────────────────────────────────────────────────────

class _TourCard extends StatelessWidget {
  final _TourGroup group;
  final void Function(_TourGroup) onTap;

  const _TourCard({required this.group, required this.onTap});

  static const _dayLabels = {1: 'Pzt', 2: 'Sal', 3: 'Çar', 4: 'Per', 5: 'Cum', 6: 'Cmt', 7: 'Paz'};

  @override
  Widget build(BuildContext context) {
    final tour = group.representative;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dates = group.allDates;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onTap(group),
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
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
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
                    const SizedBox(height: 6),
                    _statusChip(tour.isDeleted),
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
              (date) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  fmt.format(date),
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

  static Widget _departureDaysChip(TourEntity tour) {
    if (tour.departureDays.isEmpty) return const SizedBox.shrink();
    final label = tour.departureDays.map((d) => _dayLabels[d] ?? '').join(', ');
    return _chip(AppColors.info, label);
  }

  static Widget _statusChip(bool isDeleted) {
    final color = isDeleted ? AppColors.error : AppColors.success;
    final label = isDeleted ? 'Pasif' : 'Aktif';
    return _chip(color, label);
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

  static Widget _imagePlaceholder() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.image, color: AppColors.slate400),
    );
  }
}
