import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) {
    return repository.signUp(email: email, password: password, name: name, role: role);
  }
}
