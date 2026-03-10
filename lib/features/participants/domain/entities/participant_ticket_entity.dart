import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_ticket_entity.freezed.dart';

@freezed
class ParticipantTicketEntity with _$ParticipantTicketEntity {
  const factory ParticipantTicketEntity({
    String? id,
    required String tourId,
    required String userId,
    required String companyId,
    required String slotId,
    required String passengerName,
    required String tcNo,
    required double pricePaid,
    required String status,
    String? qrToken,
    required bool isScanned,
    DateTime? purchaseDate,
    DateTime? scannedAt,
    DateTime? departureDate,
  }) = _ParticipantTicketEntity;
}
