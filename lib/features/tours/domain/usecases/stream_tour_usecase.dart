import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tour_entity.dart';
import '../repositories/i_tour_repository.dart';

class StreamTourUseCase {
  final ITourRepository repository;
  const StreamTourUseCase(this.repository);

  Stream<Either<Failure, TourEntity?>> call(String tourId) => repository.streamTour(tourId);
}
