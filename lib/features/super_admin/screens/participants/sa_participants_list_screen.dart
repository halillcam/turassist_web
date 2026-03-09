import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/ticket_model.dart';
import '../../../../core/models/user_model.dart';
import '../../services/super_admin_service.dart';

class _ParticipantRowData {
  final TicketModel ticket;
  final UserModel? user;

  const _ParticipantRowData({required this.ticket, required this.user});
}

class SaParticipantsListScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const SaParticipantsListScreen({super.key, required this.tourId, this.departureDate});

  Future<List<_ParticipantRowData>> _loadParticipantRows(
    SuperAdminService service,
    List<TicketModel> tickets,
  ) async {
    final users = await Future.wait(tickets.map((ticket) => service.getUserByUid(ticket.userId)));
    return List.generate(
      tickets.length,
      (index) => _ParticipantRowData(ticket: tickets[index], user: users[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = SuperAdminService();

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
                if (departureDate != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd.MM.yyyy').format(departureDate!),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<TicketModel>>(
                stream: service.streamTourTickets(tourId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final allTickets = snapshot.data!;
                  final tickets = departureDate != null
                      ? allTickets.where((ticket) {
                          final ticketDate = ticket.departureDate;
                          if (ticketDate == null) return false;
                          return ticketDate.year == departureDate!.year &&
                              ticketDate.month == departureDate!.month &&
                              ticketDate.day == departureDate!.day;
                        }).toList()
                      : allTickets;
                  if (tickets.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz katılımcı bulunmuyor.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return FutureBuilder<List<_ParticipantRowData>>(
                    future: _loadParticipantRows(service, tickets),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final rows = userSnapshot.data!;
                      return Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              AppColors.primary.withAlpha(20),
                            ),
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Ad Soyad')),
                              DataColumn(label: Text('Müşteri ID')),
                              DataColumn(label: Text('Satış Tipi')),
                              DataColumn(label: Text('TC No')),
                              DataColumn(label: Text('Ödenen Tutar')),
                              DataColumn(label: Text('Durum')),
                              DataColumn(label: Text('QR Okutma')),
                              DataColumn(label: Text('Satın Alma')),
                            ],
                            rows: rows.asMap().entries.map((entry) {
                              final i = entry.key;
                              final row = entry.value;
                              final t = row.ticket;
                              final user = row.user;
                              final dateStr = t.purchaseDate != null
                                  ? DateFormat('dd.MM.yyyy').format(t.purchaseDate!)
                                  : '-';
                              final loginId = user?.loginId?.trim().isNotEmpty == true
                                  ? user!.loginId!
                                  : '-';
                              final saleType = user?.isPanelManagedCustomer == true
                                  ? 'Fiziksel Satış'
                                  : 'Uygulama';
                              return DataRow(
                                cells: [
                                  DataCell(Text('${i + 1}')),
                                  DataCell(Text(t.passengerName)),
                                  DataCell(Text(loginId)),
                                  DataCell(_sourceChip(saleType)),
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

  Widget _sourceChip(String label) {
    final isPhysical = label == 'Fiziksel Satış';
    final color = isPhysical ? AppColors.info : AppColors.slate400;
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
