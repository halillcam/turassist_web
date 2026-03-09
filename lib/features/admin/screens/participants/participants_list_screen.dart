import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/ticket_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../participants/presentation/controllers/participant_controller.dart';

// Satır veri modeli  yalnızca bu ekrana özgü, UI katmanında kalabilir.
class _ParticipantRowData {
  final TicketModel ticket;
  final UserModel? user;
  const _ParticipantRowData({required this.ticket, required this.user});
}

class ParticipantsListScreen extends StatefulWidget {
  final String tourId;
  final DateTime? departureDate;

  const ParticipantsListScreen({super.key, required this.tourId, this.departureDate});

  @override
  State<ParticipantsListScreen> createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  late final ParticipantController _controller;

  @override
  void initState() {
    super.initState();
    // Binding tarafından enjekte edilen ParticipantController alınır
    _controller = Get.find<ParticipantController>();
    _controller.watchTickets(widget.tourId);
  }

  @override
  void dispose() {
    _controller.stopWatching();
    super.dispose();
  }

  Future<List<_ParticipantRowData>> _buildRows(List<TicketModel> tickets) async {
    final users = await Future.wait(tickets.map((t) => _controller.getTicketUser(t.userId)));
    return List.generate(
      tickets.length,
      (i) => _ParticipantRowData(ticket: tickets[i], user: users[i]),
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
            _HeaderRow(departureDate: widget.departureDate),
            const SizedBox(height: 16),
            // Reaktif liste: tickets degistiginde otomatik yeniden cizer
            Expanded(
              child: Obx(() {
                final allTickets = _controller.tickets.toList();
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tickets = widget.departureDate != null
                    ? allTickets.where((t) {
                        final b = widget.departureDate!;
                        return t.departureDate != null &&
                            t.departureDate!.year == b.year &&
                            t.departureDate!.month == b.month &&
                            t.departureDate!.day == b.day;
                      }).toList()
                    : allTickets;

                if (tickets.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henuz katilimci bulunmuyor.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return FutureBuilder<List<_ParticipantRowData>>(
                  future: _buildRows(tickets),
                  builder: (_, snap) {
                    if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                    return _ParticipantDataTable(rows: snap.data!);
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

// ---------------------------------------------------------------------------
// Dumb widget  baslik satiri (tarih badge dahil)
// ---------------------------------------------------------------------------
class _HeaderRow extends StatelessWidget {
  final DateTime? departureDate;
  const _HeaderRow({this.departureDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people, color: AppColors.primary),
        const SizedBox(width: 8),
        const Text(
          AppStrings.participants,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Dumb widget  katilimci veri tablosu
// ---------------------------------------------------------------------------
class _ParticipantDataTable extends StatelessWidget {
  final List<_ParticipantRowData> rows;
  const _ParticipantDataTable({required this.rows});

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
            DataColumn(label: Text('Musteri ID')),
            DataColumn(label: Text('Satis Tipi')),
            DataColumn(label: Text('TC No')),
            DataColumn(label: Text('Odenen Tutar')),
            DataColumn(label: Text('Durum')),
            DataColumn(label: Text('QR Okutma')),
            DataColumn(label: Text('Satin Alma')),
          ],
          rows: rows.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value.ticket;
            final user = entry.value.user;
            final dateStr = t.purchaseDate != null
                ? DateFormat('dd.MM.yyyy').format(t.purchaseDate!)
                : '-';
            final loginId = user?.loginId?.trim().isNotEmpty == true ? user!.loginId! : '-';
            final saleType = user?.isPanelManagedCustomer == true ? 'Fiziksel Satis' : 'Uygulama';
            return DataRow(
              cells: [
                DataCell(Text('${i + 1}')),
                DataCell(Text(t.passengerName)),
                DataCell(Text(loginId)),
                DataCell(_sourceChip(saleType)),
                DataCell(Text(t.tcNo.isEmpty ? '-' : t.tcNo)),
                DataCell(Text('${t.pricePaid.toStringAsFixed(0)}')),
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
  }

  static Widget _statusChip(String status) {
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

  static Widget _sourceChip(String label) {
    final isPhysical = label.contains('Fiziksel');
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
