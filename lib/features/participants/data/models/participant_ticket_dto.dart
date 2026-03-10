import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/participant_ticket_entity.dart';

part 'participant_ticket_dto.freezed.dart';

DateTime? _timestampToDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return null;
}

@freezed
class ParticipantTicketDto with _$ParticipantTicketDto {
  const factory ParticipantTicketDto({
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
  }) = _ParticipantTicketDto;

  factory ParticipantTicketDto.fromFirestore(Map<String, dynamic> map, String docId) {
    return ParticipantTicketDto(
      id: docId,
      tourId: map['tourId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      companyId: map['companyId'] as String? ?? '',
      slotId: map['slotId'] as String? ?? '',
      passengerName: map['passengerName'] as String? ?? '',
      tcNo: map['tcNo'] as String? ?? '',
      pricePaid: (map['pricePaid'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'active',
      qrToken: map['qrToken'] as String?,
      isScanned: map['isScanned'] as bool? ?? false,
      purchaseDate: _timestampToDateTime(map['purchaseDate']),
      scannedAt: _timestampToDateTime(map['scannedAt']),
      departureDate: _timestampToDateTime(map['departureDate']),
    );
  }
}

extension ParticipantTicketDtoMapper on ParticipantTicketDto {
  ParticipantTicketEntity toEntity() {
    return ParticipantTicketEntity(
      id: id,
      tourId: tourId,
      userId: userId,
      companyId: companyId,
      slotId: slotId,
      passengerName: passengerName,
      tcNo: tcNo,
      pricePaid: pricePaid,
      status: status,
      qrToken: qrToken,
      isScanned: isScanned,
      purchaseDate: purchaseDate,
      scannedAt: scannedAt,
      departureDate: departureDate,
    );
  }
}
