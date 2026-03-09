import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_tour_repository.dart';

class UpdateTourUseCase {
  final ITourRepository repository;
  const UpdateTourUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String tourId, Map<String, dynamic> data) =>
      repository.updateTour(tourId, data);
}
