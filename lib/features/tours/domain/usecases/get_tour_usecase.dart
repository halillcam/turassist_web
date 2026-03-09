import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tour_entity.dart';
import '../repositories/i_tour_repository.dart';

class GetTourUseCase {
  final ITourRepository repository;
  const GetTourUseCase(this.repository);

  Future<Either<Failure, TourEntity>> call(String tourId) => repository.getTour(tourId);
}
