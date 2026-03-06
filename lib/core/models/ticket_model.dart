import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String? id;
  final String tourId;
  final String userId;
  final String companyId;
  final String slotId;
  final String passengerName;
  final String tcNo;
  final double pricePaid;
  final String status;
  final String? qrToken;
  final bool isScanned;
  final DateTime? purchaseDate;
  final DateTime? scannedAt;
  final DateTime? departureDate;

  TicketModel({
    this.id,
    required this.tourId,
    required this.userId,
    required this.companyId,
    this.slotId = '',
    required this.passengerName,
    this.tcNo = '',
    required this.pricePaid,
    this.status = 'active',
    this.qrToken,
    this.isScanned = false,
    this.purchaseDate,
    this.scannedAt,
    this.departureDate,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map, String docId) {
    return TicketModel(
      id: docId,
      tourId: map['tourId'] ?? '',
      userId: map['userId'] ?? '',
      companyId: map['companyId'] ?? '',
      slotId: map['slotId'] ?? '',
      passengerName: map['passengerName'] ?? '',
      tcNo: map['tcNo'] ?? '',
      pricePaid: (map['pricePaid'] ?? 0).toDouble(),
      status: map['status'] ?? 'active',
      qrToken: map['qrToken'],
      isScanned: map['isScanned'] ?? false,
      purchaseDate: map['purchaseDate'] != null
          ? (map['purchaseDate'] as Timestamp).toDate()
          : null,
      scannedAt: map['scannedAt'] != null ? (map['scannedAt'] as Timestamp).toDate() : null,
      departureDate: map['departureDate'] != null
          ? (map['departureDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tourId': tourId,
      'userId': userId,
      'companyId': companyId,
      'slotId': slotId,
      'passengerName': passengerName,
      'tcNo': tcNo,
      'pricePaid': pricePaid,
      'status': status,
      'qrToken': qrToken,
      'isScanned': isScanned,
      'purchaseDate': purchaseDate != null
          ? Timestamp.fromDate(purchaseDate!)
          : FieldValue.serverTimestamp(),
      'scannedAt': scannedAt != null ? Timestamp.fromDate(scannedAt!) : null,
      'departureDate': departureDate != null ? Timestamp.fromDate(departureDate!) : null,
    };
  }
}
