import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/managed_user_entity.dart';
import '../repositories/i_user_repository.dart';

class WatchUsersUseCase {
  final IUserRepository repository;

  const WatchUsersUseCase(this.repository);

  Stream<Either<Failure, List<ManagedUserEntity>>> call() => repository.watchUsers();
}
