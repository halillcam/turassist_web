import 'package:cloud_firestore/cloud_firestore.dart';

class TourCommunicationItem {
  final String id;
  final String title;
  final String body;
  final String senderName;
  final String senderRole;
  final DateTime? createdAt;
  final Map<String, dynamic> rawData;

  const TourCommunicationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.senderName,
    required this.senderRole,
    required this.createdAt,
    required this.rawData,
  });

  factory TourCommunicationItem.fromMap(Map<String, dynamic> map, String docId) {
    final timestamp = map['createdAt'];
    return TourCommunicationItem(
      id: docId,
      title: _pick(map, const ['title', 'subject', 'header']),
      body: _pick(map, const ['message', 'body', 'text', 'content', 'description']),
      senderName: _pick(map, const [
        'senderName',
        'fullName',
        'userName',
        'authorName',
        'guideName',
      ]),
      senderRole: _pick(map, const ['senderRole', 'role', 'userRole', 'authorRole']),
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
      rawData: map,
    );
  }

  static String _pick(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }
}
