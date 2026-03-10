import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/managed_user_entity.dart';
import '../repositories/i_user_repository.dart';

class GetUserUseCase {
  final IUserRepository repository;

  const GetUserUseCase(this.repository);

  Future<Either<Failure, ManagedUserEntity?>> call(String uid) {
    return repository.getUserByUid(uid);
  }
}
