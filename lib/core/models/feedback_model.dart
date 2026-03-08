import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String? id;
  final String companyId;
  final String title;
  final String description;
  final String senderName;
  final String senderPhone;
  final bool isResolved;
  final String? resolvedBy;
  final Timestamp? resolvedAt;
  final Timestamp? createdAt;

  FeedbackModel({
    this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.senderName,
    required this.senderPhone,
    this.isResolved = false,
    this.resolvedBy,
    this.resolvedAt,
    this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      companyId: map['companyId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      isResolved: map['isResolved'] == true,
      resolvedBy: map['resolvedBy'] as String?,
      resolvedAt: map['resolvedAt'] is Timestamp ? map['resolvedAt'] as Timestamp : null,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'isResolved': isResolved,
      'resolvedBy': resolvedBy,
      'resolvedAt': resolvedAt,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
