import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/participant_ticket_entity.dart';
import '../entities/participant_user_entity.dart';

abstract class IParticipantRepository {
  Stream<Either<Failure, List<ParticipantTicketEntity>>> watchTickets(String tourId);
  Future<Either<Failure, ParticipantUserEntity?>> getParticipantUser(String userId);
  Future<Either<Failure, Unit>> addParticipant({
    required String loginId,
    required String password,
    required String fullName,
    required String phone,
    required String tcNo,
    required String tourId,
    required String companyId,
    required double pricePaid,
    DateTime? departureDate,
  });
}
