import 'package:cloud_firestore/cloud_firestore.dart';

class TourCompletionRequestModel {
  final String? id;
  final String tourId;
  final String tourTitle;
  final String guideId;
  final String companyId;
  final bool isApproved;
  final Timestamp? requestedAt;

  TourCompletionRequestModel({
    this.id,
    required this.tourId,
    required this.tourTitle,
    required this.guideId,
    required this.companyId,
    this.isApproved = false,
    this.requestedAt,
  });

  factory TourCompletionRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return TourCompletionRequestModel(
      id: docId,
      tourId: map['tourId'] ?? '',
      tourTitle: map['tourTitle'] ?? '',
      guideId: map['guideId'] ?? '',
      companyId: map['companyId'] ?? '',
      isApproved: map['isApproved'] ?? false,
      requestedAt: map['requestedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tourId': tourId,
      'tourTitle': tourTitle,
      'guideId': guideId,
      'companyId': companyId,
      'isApproved': isApproved,
      'requestedAt': requestedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
