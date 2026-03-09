import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository repository;

  const SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}
