import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/models/tour_model.dart';
import '../../services/admin_tour_service.dart';

class ActiveToursScreen extends StatefulWidget {
  final String companyId;

  const ActiveToursScreen({super.key, required this.companyId});

  @override
  State<ActiveToursScreen> createState() => _ActiveToursScreenState();
}

class _ActiveToursScreenState extends State<ActiveToursScreen> {
  final _service = AdminTourService();

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
                stream: _service.streamActiveTours(widget.companyId),
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
                  return _TourListView(tours: tours);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourListView extends StatelessWidget {
  final List<TourModel> tours;

  const _TourListView({required this.tours});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final departureDateText = tour.departureDate != null
        ? dateFormat.format(tour.departureDate!)
        : tour.departureDays.isNotEmpty
        ? _departureDaysText(tour.departureDays)
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail, arguments: tour.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Tur görseli
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
              // Bilgiler
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
              // Sağ taraf: fiyat, kapasite, çıkış
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

  static const _dayLabels = {1: 'Pzt', 2: 'Sal', 3: 'Çar', 4: 'Per', 5: 'Cum', 6: 'Cmt', 7: 'Paz'};

  static String _departureDaysText(List<int> days) {
    return days.map((d) => _dayLabels[d] ?? '').join(', ');
  }
}
