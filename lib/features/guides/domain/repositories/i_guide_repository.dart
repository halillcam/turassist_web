import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class IGuideRepository {
  Future<Either<Failure, Unit>> addGuide({
    required String guideId,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  });
}