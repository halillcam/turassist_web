import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/participant_ticket_entity.dart';
import '../repositories/i_participant_repository.dart';

class WatchTicketsUseCase {
  final IParticipantRepository repository;

  const WatchTicketsUseCase(this.repository);

  Stream<Either<Failure, List<ParticipantTicketEntity>>> call(String tourId) {
    return repository.watchTickets(tourId);
  }
}
