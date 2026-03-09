import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../tours/domain/entities/tour_entity.dart';
import '../../../tours/presentation/controllers/tour_controller.dart';

class PassiveToursScreen extends StatefulWidget {
  final String companyId;

  const PassiveToursScreen({super.key, required this.companyId});

  @override
  State<PassiveToursScreen> createState() => _PassiveToursScreenState();
}

class _PassiveToursScreenState extends State<PassiveToursScreen>
    with SingleTickerProviderStateMixin {
  late final TourController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Binding tarafından enjekte edilen TourController alınır
    _controller = Get.find<TourController>();
    _tabController = TabController(length: 2, vsync: this);
    _controller.loadDeletedTours(widget.companyId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTap(BuildContext context, TourEntity tour) {
    Navigator.pushNamed(
      context,
      AppRoutes.toursSchedule,
      arguments: {
        'companyId': tour.companyId,
        'representativeTourId': tour.id,
        'seriesId': tour.seriesId,
        'isDeleted': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.passiveTours),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Geçmiş Turlar'),
            Tab(text: 'Gelecek Turlar'),
          ],
        ),
      ),
      // Reaktif liste: TourController.deletedTours değiştiğinde yeniden çizer
      body: Obx(() {
        final allTours = _controller.deletedTours;

        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final pastTours = allTours
            .where((t) => t.departureDate != null && t.departureDate!.isBefore(now))
            .toList();
        final futureTours = allTours
            .where((t) => t.departureDate == null || !t.departureDate!.isBefore(now))
            .toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _PassiveTourList(
              tours: pastTours,
              emptyMessage: 'Geçmiş tur bulunmuyor.',
              onTap: (t) => _handleTap(context, t),
            ),
            _PassiveTourList(
              tours: futureTours,
              emptyMessage: 'Gelecek pasif tur bulunmuyor.',
              onTap: (t) => _handleTap(context, t),
            ),
          ],
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Dumb widget – liste veya boş durum gösterir
// ---------------------------------------------------------------------------
class _PassiveTourList extends StatelessWidget {
  final List<TourEntity> tours;
  final String emptyMessage;
  final ValueChanged<TourEntity> onTap;

  const _PassiveTourList({required this.tours, required this.emptyMessage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) {
      return _EmptyTours(message: emptyMessage);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: tours.length,
      itemBuilder: (_, i) => _PassiveTourCard(tour: tours[i], onTap: () => onTap(tours[i])),
    );
  }
}

// ---------------------------------------------------------------------------
// Dumb widget – boş durum
// ---------------------------------------------------------------------------
class _EmptyTours extends StatelessWidget {
  final String message;
  const _EmptyTours({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, size: 64, color: AppColors.slate300),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dumb widget – tek tur kartı
// ---------------------------------------------------------------------------
class _PassiveTourCard extends StatelessWidget {
  final TourEntity tour;
  final VoidCallback onTap;

  const _PassiveTourCard({required this.tour, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateText = tour.departureDate != null
        ? DateFormat('dd.MM.yyyy').format(tour.departureDate!)
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.slate100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.tour, color: AppColors.slate400),
        ),
        title: Text(tour.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${tour.city} • ${tour.region} • $dateText',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        isThreeLine: true,
        trailing: Text(
          '₺${tour.price.toStringAsFixed(0)}',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        titleAlignment: ListTileTitleAlignment.top,
        minVerticalPadding: 12,
        onTap: onTap,
      ),
    );
  }
}
