import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_auth_repository.dart';

class SignOutUseCase {
  final IAuthRepository repository;

  const SignOutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.signOut();
  }
}
