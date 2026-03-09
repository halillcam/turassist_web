import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tour_entity.dart';
import '../repositories/i_tour_repository.dart';

class StreamDeletedToursUseCase {
  final ITourRepository repository;
  const StreamDeletedToursUseCase(this.repository);

  Stream<Either<Failure, List<TourEntity>>> call(String companyId) =>
      repository.streamDeletedTours(companyId);
}
