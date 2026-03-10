import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/managed_user_entity.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/managed_user_dto.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserRemoteDataSource _dataSource;

  const UserRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<ManagedUserEntity>>> watchUsers() {
    return _dataSource.watchUsers().map(
      (users) => Right(users.map((user) => user.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> addUser(CreateManagedUserPayload payload) async {
    try {
      await _dataSource.addUser(payload);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _dataSource.updateUser(uid, data);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setUserActive(String uid, {required bool isActive}) async {
    try {
      await _dataSource.setUserActive(uid, isActive: isActive);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ManagedUserEntity?>> getUserByUid(String uid) async {
    try {
      final user = await _dataSource.getUserByUid(uid);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
