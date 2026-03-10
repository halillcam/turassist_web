import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/participant_ticket_entity.dart';
import '../../domain/entities/participant_user_entity.dart';

class ParticipantRowData {
  final ParticipantTicketEntity ticket;
  final ParticipantUserEntity? user;

  const ParticipantRowData({required this.ticket, required this.user});
}

class ParticipantDataTable extends StatelessWidget {
  final List<ParticipantRowData> rows;

  const ParticipantDataTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primary.withAlpha(20)),
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
            final index = entry.key;
            final ticket = entry.value.ticket;
            final user = entry.value.user;
            final saleType = user?.isPanelManagedCustomer == true ? 'Fiziksel Satış' : 'Uygulama';
            final purchaseDate = ticket.purchaseDate != null
                ? DateFormat('dd.MM.yyyy').format(ticket.purchaseDate!)
                : '-';
            final loginId = user?.loginId.trim().isNotEmpty == true ? user!.loginId : '-';

            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(Text(ticket.passengerName)),
                DataCell(Text(loginId)),
                DataCell(
                  _chip(
                    saleType,
                    saleType == 'Fiziksel Satış' ? AppColors.info : AppColors.slate400,
                  ),
                ),
                DataCell(Text(ticket.tcNo.isEmpty ? '-' : ticket.tcNo)),
                DataCell(Text('₺${ticket.pricePaid.toStringAsFixed(0)}')),
                DataCell(
                  _chip(
                    ticket.status == 'active' ? 'Aktif' : ticket.status,
                    ticket.status == 'active' ? AppColors.success : AppColors.slate400,
                  ),
                ),
                DataCell(
                  Icon(
                    ticket.isScanned ? Icons.check_circle : Icons.cancel,
                    color: ticket.isScanned ? AppColors.success : AppColors.slate400,
                    size: 20,
                  ),
                ),
                DataCell(Text(purchaseDate)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
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
