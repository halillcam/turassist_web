import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/models/tour_model.dart';
import '../../controllers/admin_tour_controller.dart';

class PassiveToursScreen extends StatefulWidget {
  final String companyId;

  const PassiveToursScreen({super.key, required this.companyId});

  @override
  State<PassiveToursScreen> createState() => _PassiveToursScreenState();
}

class _PassiveToursScreenState extends State<PassiveToursScreen>
    with SingleTickerProviderStateMixin {
  late final AdminTourController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminTourController>();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text(AppStrings.passiveTours),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Geçmiş Turlar'),
            Tab(text: 'Gelecek Turlar'),
          ],
        ),
      ),
      body: StreamBuilder<List<TourModel>>(
        stream: _controller.streamDeletedTours(widget.companyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final allTours = snapshot.data ?? [];
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
              _buildTourList(pastTours, 'Geçmiş tur bulunmuyor.'),
              _buildTourList(futureTours, 'Gelecek pasif tur bulunmuyor.'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTourList(List<TourModel> tours, String emptyMessage) {
    if (tours.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 64, color: AppColors.slate300),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        final dateFormat = DateFormat('dd.MM.yyyy');
        final dateText = tour.departureDate != null ? dateFormat.format(tour.departureDate!) : '-';

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
            onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail, arguments: tour.id),
          ),
        );
      },
    );
  }
}
