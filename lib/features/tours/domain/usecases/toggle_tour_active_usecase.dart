import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_tour_repository.dart';

class ToggleTourActiveUseCase {
  final ITourRepository repository;
  const ToggleTourActiveUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String tourId, {required bool isActive}) =>
      repository.setTourActive(tourId, isActive: isActive);
}
