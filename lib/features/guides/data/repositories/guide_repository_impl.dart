import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/i_guide_repository.dart';
import '../datasources/guide_remote_data_source.dart';

class GuideRepositoryImpl implements IGuideRepository {
  final IGuideRemoteDataSource _remoteDataSource;

  const GuideRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> addGuide({
    required String guideId,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) async {
    try {
      await _remoteDataSource.addGuide(
        AddGuideRemotePayload(
          guideId: guideId,
          password: password,
          fullName: fullName,
          phone: phone,
          tourId: tourId,
          companyId: companyId,
        ),
      );
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}