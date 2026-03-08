import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/ticket_model.dart';
import '../../controllers/admin_tour_controller.dart';

class ParticipantsListScreen extends StatefulWidget {
  final String tourId;

  const ParticipantsListScreen({super.key, required this.tourId});

  @override
  State<ParticipantsListScreen> createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  late final AdminTourController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AdminTourController>();
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
              children: const [
                Icon(Icons.people, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  AppStrings.participants,
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
              child: StreamBuilder<List<TicketModel>>(
                stream: _controller.streamTourTickets(widget.tourId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tickets = snapshot.data!;
                  if (tickets.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz katılımcı bulunmuyor.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.primary.withAlpha(20)),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Ad Soyad')),
                          DataColumn(label: Text('TC No')),
                          DataColumn(label: Text('Ödenen Tutar')),
                          DataColumn(label: Text('Durum')),
                          DataColumn(label: Text('QR Okutma')),
                          DataColumn(label: Text('Satın Alma')),
                        ],
                        rows: tickets.asMap().entries.map((entry) {
                          final i = entry.key;
                          final t = entry.value;
                          final dateStr = t.purchaseDate != null
                              ? DateFormat('dd.MM.yyyy').format(t.purchaseDate!)
                              : '-';
                          return DataRow(
                            cells: [
                              DataCell(Text('${i + 1}')),
                              DataCell(Text(t.passengerName)),
                              DataCell(Text(t.tcNo.isEmpty ? '-' : t.tcNo)),
                              DataCell(Text('₺${t.pricePaid.toStringAsFixed(0)}')),
                              DataCell(_statusChip(t.status)),
                              DataCell(
                                Icon(
                                  t.isScanned ? Icons.check_circle : Icons.cancel,
                                  color: t.isScanned ? AppColors.success : AppColors.slate400,
                                  size: 20,
                                ),
                              ),
                              DataCell(Text(dateStr)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = status == 'active' ? AppColors.success : AppColors.slate400;
    final label = status == 'active' ? 'Aktif' : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
