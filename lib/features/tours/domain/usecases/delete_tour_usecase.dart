import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_tour_repository.dart';

class DeleteTourUseCase {
  final ITourRepository repository;
  const DeleteTourUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String tourId) => repository.deleteTour(tourId);
}
