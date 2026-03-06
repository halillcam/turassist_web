import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/company_model.dart';
import '../../../../core/models/tour_model.dart';
import '../../controllers/sa_tour_controller.dart';

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
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return _TourCard(tour: tour);
      },
    );
  }
}

class _TourCard extends StatelessWidget {
  final TourModel tour;
  const _TourCard({required this.tour});

  static const _dayLabels = {1: 'Pzt', 2: 'Sal', 3: 'Çar', 4: 'Per', 5: 'Cum', 6: 'Cmt', 7: 'Paz'};

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final departureDateText = tour.departureDate != null
        ? dateFormat.format(tour.departureDate!)
        : tour.departureDays.isNotEmpty
        ? tour.departureDays.map((d) => _dayLabels[d] ?? '').join(', ')
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (tour.id != null) {
            Navigator.pushNamed(context, AppRoutes.superAdminTourDetail, arguments: tour.id);
          }
        },
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
                  const SizedBox(height: 2),
                  Text(
                    'Çıkış: $departureDateText',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.slate400),
            ],
          ),
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
}
