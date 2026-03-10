import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_guide_repository.dart';

class AddGuideParams {
  final String guideId;
  final String password;
  final String fullName;
  final String phone;
  final String tourId;
  final String companyId;

  const AddGuideParams({
    required this.guideId,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.tourId,
    required this.companyId,
  });
}

class AddGuideUseCase {
  final IGuideRepository repository;

  const AddGuideUseCase(this.repository);

  Future<Either<Failure, Unit>> call(AddGuideParams params) {
    return repository.addGuide(
      guideId: params.guideId,
      password: params.password,
      fullName: params.fullName,
      phone: params.phone,
      tourId: params.tourId,
      companyId: params.companyId,
    );
  }
}