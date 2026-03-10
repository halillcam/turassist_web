import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/participant_ticket_entity.dart';
import '../../domain/entities/participant_user_entity.dart';
import '../../domain/repositories/i_participant_repository.dart';
import '../datasources/participant_remote_data_source.dart';
import '../models/participant_ticket_dto.dart';
import '../models/participant_user_dto.dart';

class ParticipantRepositoryImpl implements IParticipantRepository {
  final IParticipantRemoteDataSource _remoteDataSource;

  const ParticipantRepositoryImpl(this._remoteDataSource);

  @override
  Stream<Either<Failure, List<ParticipantTicketEntity>>> watchTickets(String tourId) {
    return _remoteDataSource
        .watchTickets(tourId)
        .map(
          (tickets) => Right<Failure, List<ParticipantTicketEntity>>(
            tickets.map((ticket) => ticket.toEntity()).toList(),
          ),
        )
        .handleError((error) => Left(ServerFailure(error.toString())));
  }

  @override
  Future<Either<Failure, ParticipantUserEntity?>> getParticipantUser(String userId) async {
    try {
      final user = await _remoteDataSource.getParticipantUser(userId);
      return Right(user?.toEntity());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
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
  }) async {
    try {
      await _remoteDataSource.addParticipant(
        AddParticipantRemotePayload(
          loginId: loginId,
          password: password,
          fullName: fullName,
          phone: phone,
          tcNo: tcNo,
          tourId: tourId,
          companyId: companyId,
          pricePaid: pricePaid,
          departureDate: departureDate,
        ),
      );
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
