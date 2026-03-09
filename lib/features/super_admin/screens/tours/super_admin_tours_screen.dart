import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/company_model.dart';
import '../../../../core/models/tour_model.dart';
import '../../controllers/sa_tour_controller.dart';
import 'sa_tour_schedule_screen.dart';

class SuperAdminToursScreen extends StatefulWidget {
  const SuperAdminToursScreen({super.key});

  @override
  State<SuperAdminToursScreen> createState() => _SuperAdminToursScreenState();
}

class _SuperAdminToursScreenState extends State<SuperAdminToursScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SATourController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tours),
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
          _buildCompanySelector(controller),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Obx(() => _buildTourList(controller.activeTours.toList(), 'Aktif tur bulunmuyor.')),
                Obx(
                  () => _buildTourList(controller.deletedTours.toList(), 'Pasif tur bulunmuyor.'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final companyId = controller.selectedCompanyId.value;
        if (companyId == null) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.saAddTour, arguments: companyId),
          icon: const Icon(Icons.add),
          label: const Text('Tur Ekle'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        );
      }),
    );
  }

  Widget _buildCompanySelector(SATourController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Obx(() {
        final companies = controller.companies;
        final selected = controller.selectedCompanyId.value;

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
                initialValue: selected,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                hint: const Text('Şirket seçin'),
                items: companies.map((CompanyModel c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.companyName));
                }).toList(),
                onChanged: (val) => controller.selectCompany(val),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTourList(List<TourModel> tours, String emptyText) {
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

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _groupTours(tours).length,
      itemBuilder: (context, index) => _TourCard(group: _groupTours(tours)[index]),
    );
  }

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
    for (final instance in instances) {
      if (instance.departureDate != null) dates.add(instance.departureDate!);
    }
    if (instances.length == 1) {
      for (final date in instances.first.departureDates ?? []) {
        dates.add(date);
      }
    }
    return dates.toList()..sort();
  }

  bool get hasMultipleDates => allDates.length > 1;
}

class _TourCard extends StatelessWidget {
  final _TourGroup group;
  const _TourCard({required this.group});

  static const _dayLabels = {1: 'Pzt', 2: 'Sal', 3: 'Çar', 4: 'Per', 5: 'Cum', 6: 'Cmt', 7: 'Paz'};

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

  Future<void> _handleTap(BuildContext context) async {
    final representative = group.representative;
    final tourId = representative.id;
    if (tourId == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaTourScheduleScreen(
          companyId: representative.companyId,
          representativeTourId: tourId,
          seriesId: representative.seriesId,
          isDeleted: representative.isDeleted,
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

  static Widget _statusChip(bool isDeleted) {
    final color = isDeleted ? AppColors.error : AppColors.success;
    final label = isDeleted ? 'Pasif' : 'Aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
