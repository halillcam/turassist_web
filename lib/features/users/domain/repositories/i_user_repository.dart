import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../entities/managed_user_entity.dart';

abstract class IUserRepository {
  Stream<Either<Failure, List<ManagedUserEntity>>> watchUsers();

  Future<Either<Failure, Unit>> addUser(CreateManagedUserPayload payload);

  Future<Either<Failure, Unit>> updateUser(String uid, Map<String, dynamic> data);

  Future<Either<Failure, Unit>> setUserActive(String uid, {required bool isActive});

  Future<Either<Failure, ManagedUserEntity?>> getUserByUid(String uid);
}
