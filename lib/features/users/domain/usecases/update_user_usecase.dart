import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_user_repository.dart';

class UpdateUserUseCase {
  final IUserRepository repository;

  const UpdateUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String uid, Map<String, dynamic> data) {
    return repository.updateUser(uid, data);
  }
}
