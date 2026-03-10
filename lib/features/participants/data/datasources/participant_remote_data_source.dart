import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/auth_service.dart';
import '../models/participant_ticket_dto.dart';
import '../models/participant_user_dto.dart';

class AddParticipantRemotePayload {
  final String loginId;
  final String password;
  final String fullName;
  final String phone;
  final String tcNo;
  final String tourId;
  final String companyId;
  final double pricePaid;
  final DateTime? departureDate;

  const AddParticipantRemotePayload({
    required this.loginId,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.tcNo,
    required this.tourId,
    required this.companyId,
    required this.pricePaid,
    this.departureDate,
  });
}

abstract class IParticipantRemoteDataSource {
  Stream<List<ParticipantTicketDto>> watchTickets(String tourId);
  Future<ParticipantUserDto?> getParticipantUser(String userId);
  Future<void> addParticipant(AddParticipantRemotePayload payload);
}

class ParticipantRemoteDataSource implements IParticipantRemoteDataSource {
  final FirebaseFirestore _db;

  ParticipantRemoteDataSource({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Stream<List<ParticipantTicketDto>> watchTickets(String tourId) {
    return _db
        .collection('tickets')
        .where('tourId', isEqualTo: tourId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ParticipantTicketDto.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<ParticipantUserDto?> getParticipantUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return ParticipantUserDto.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<void> addParticipant(AddParticipantRemotePayload payload) async {
    final tourRef = _db.collection('tours').doc(payload.tourId);
    final normalized = AuthService.normalizePanelLoginId(payload.loginId);
    final email = AuthService.buildCustomerLoginEmail(normalized);
    final uid = await AuthService.createSecondaryAuthUser(email, payload.password);
    final userRef = _db.collection('users').doc(uid);
    final ticketRef = _db.collection('tickets').doc();

    final userData = {
      'loginId': normalized,
      'email': email,
      'fullName': payload.fullName,
      'phone': payload.phone,
      'tcNo': payload.tcNo,
      'role': 'customer',
      'companyId': payload.companyId,
      'isPanelManagedCustomer': true,
      'customerPassword': payload.password,
      'isDeleted': false,
    };

    final ticketData = {
      'tourId': payload.tourId,
      'userId': uid,
      'companyId': payload.companyId,
      'slotId': '',
      'passengerName': payload.fullName,
      'tcNo': payload.tcNo,
      'pricePaid': payload.pricePaid,
      'status': 'active',
      'qrToken': null,
      'isScanned': false,
      'purchaseDate': FieldValue.serverTimestamp(),
      'scannedAt': null,
      'departureDate': payload.departureDate != null
          ? Timestamp.fromDate(payload.departureDate!)
          : null,
    };

    await _db.runTransaction((transaction) async {
      final tourSnapshot = await transaction.get(tourRef);
      final tourData = tourSnapshot.data();
      final currentCapacity = (tourData?['capacity'] as num?)?.toInt() ?? 0;

      if (!tourSnapshot.exists || tourData == null) {
        throw StateError('Tur bulunamadı.');
      }
      if (currentCapacity <= 0) {
        throw StateError('Bu tur için kontenjan kalmadı.');
      }

      transaction.set(userRef, userData);
      transaction.set(ticketRef, ticketData);
      transaction.update(tourRef, {'capacity': currentCapacity - 1});
    });
  }
}
