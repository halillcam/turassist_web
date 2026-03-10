import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/participant_user_entity.dart';
import '../repositories/i_participant_repository.dart';

class GetParticipantUserUseCase {
  final IParticipantRepository repository;

  const GetParticipantUserUseCase(this.repository);

  Future<Either<Failure, ParticipantUserEntity?>> call(String userId) {
    return repository.getParticipantUser(userId);
  }
}
