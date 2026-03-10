import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/participant_ticket_entity.dart';
import '../controllers/participant_controller.dart';
import '../widgets/participant_data_table.dart';
import '../widgets/participant_date_badge.dart';

class ParticipantListScreen extends StatefulWidget {
  final String tourId;
  final DateTime? departureDate;

  const ParticipantListScreen({super.key, required this.tourId, this.departureDate});

  @override
  State<ParticipantListScreen> createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  late final ParticipantController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ParticipantController>();
    _controller.watchTickets(widget.tourId);
  }

  @override
  void dispose() {
    _controller.stopWatching();
    super.dispose();
  }

  Future<List<ParticipantRowData>> _buildRows(List<ParticipantTicketEntity> tickets) async {
    final users = await Future.wait(
      tickets.map((ticket) => _controller.getTicketUser(ticket.userId)),
    );
    return List.generate(
      tickets.length,
      (index) => ParticipantRowData(ticket: tickets[index], user: users[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.participants),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.participants,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.departureDate != null) ...[
                  const SizedBox(width: 12),
                  ParticipantDateBadge(date: widget.departureDate!),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredTickets = _controller.filterTicketsByDate(
                  _controller.tickets.toList(),
                  widget.departureDate,
                );

                if (filteredTickets.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz katılımcı bulunmuyor.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return FutureBuilder<List<ParticipantRowData>>(
                  future: _buildRows(filteredTickets),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ParticipantDataTable(rows: snapshot.data!);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
