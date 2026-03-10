import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_user_repository.dart';

class SetUserActiveUseCase {
  final IUserRepository repository;

  const SetUserActiveUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String uid, {required bool isActive}) {
    return repository.setUserActive(uid, isActive: isActive);
  }
}
