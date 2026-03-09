import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tour_entity.dart';
import '../repositories/i_tour_repository.dart';

class AddTourUseCase {
  final ITourRepository repository;
  const AddTourUseCase(this.repository);

  /// Tek kalkış tarihli tur ekler. Dönen String yeni dökümanın ID'sidir.
  Future<Either<Failure, String>> call(TourEntity tour) => repository.addTour(tour);
}
