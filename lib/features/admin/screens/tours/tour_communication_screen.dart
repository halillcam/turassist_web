import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/tour_communication_item.dart';
import '../../controllers/admin_tour_controller.dart';

class TourCommunicationScreen extends StatefulWidget {
  final String tourId;
  final String tourTitle;
  final int initialTabIndex;

  const TourCommunicationScreen({
    super.key,
    required this.tourId,
    required this.tourTitle,
    this.initialTabIndex = 0,
  });

  @override
  State<TourCommunicationScreen> createState() => _TourCommunicationScreenState();
}

class _TourCommunicationScreenState extends State<TourCommunicationScreen>
    with SingleTickerProviderStateMixin {
  late final AdminTourController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminTourController>();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
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
        title: Text(widget.tourTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Mesajlar'),
            Tab(text: 'Duyurular'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CommunicationList(
            stream: _controller.streamTourMessages(widget.tourId),
            emptyText: 'Bu tur için henüz mesaj yok.',
            emptyIcon: Icons.forum_outlined,
            showSender: true,
          ),
          _CommunicationList(
            stream: _controller.streamTourAnnouncements(widget.tourId),
            emptyText: 'Bu tur için henüz duyuru yok.',
            emptyIcon: Icons.campaign_outlined,
            showSender: false,
          ),
        ],
      ),
    );
  }
}

class _CommunicationList extends StatelessWidget {
  final Stream<List<TourCommunicationItem>> stream;
  final String emptyText;
  final IconData emptyIcon;
  final bool showSender;

  const _CommunicationList({
    required this.stream,
    required this.emptyText,
    required this.emptyIcon,
    required this.showSender,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TourCommunicationItem>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Veriler yüklenemedi: ${snapshot.error}',
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }

        final items = snapshot.data ?? const <TourCommunicationItem>[];
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(emptyIcon, size: 54, color: AppColors.slate400),
                const SizedBox(height: 12),
                Text(emptyText, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _CommunicationCard(item: items[index], showSender: showSender),
        );
      },
    );
  }
}

class _CommunicationCard extends StatelessWidget {
  final TourCommunicationItem item;
  final bool showSender;

  const _CommunicationCard({required this.item, required this.showSender});

  @override
  Widget build(BuildContext context) {
    final title = item.title.isNotEmpty ? item.title : (showSender ? 'Mesaj' : 'Duyuru');
    final body = item.body.isNotEmpty ? item.body : _fallbackBody(item.rawData);
    final createdAtText = item.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt!)
        : 'Tarih yok';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    createdAtText,
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (showSender) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _metaChip(
                    Icons.person_outline,
                    item.senderName.isNotEmpty ? item.senderName : 'Gönderen bilinmiyor',
                  ),
                  if (item.senderRole.isNotEmpty) _metaChip(Icons.badge_outlined, item.senderRole),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Text(body, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
          ],
        ),
      ),
    );
  }

  static Widget _metaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlayDark,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.slate400),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        ],
      ),
    );
  }

  static String _fallbackBody(Map<String, dynamic> rawData) {
    final entries = rawData.entries
        .where((entry) => entry.value != null)
        .where((entry) => entry.key != 'createdAt')
        .take(6)
        .map((entry) => '${entry.key}: ${entry.value}')
        .toList();
    return entries.isEmpty ? 'İçerik bulunamadı.' : entries.join('\n');
  }
}
