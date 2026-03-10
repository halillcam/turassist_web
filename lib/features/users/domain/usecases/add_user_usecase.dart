import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../repositories/i_user_repository.dart';

class AddUserUseCase {
  final IUserRepository repository;

  const AddUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(CreateManagedUserPayload payload) {
    return repository.addUser(payload);
  }
}
