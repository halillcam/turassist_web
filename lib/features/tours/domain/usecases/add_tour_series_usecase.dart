import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tour_entity.dart';
import '../repositories/i_tour_repository.dart';

class AddTourSeriesUseCase {
  final ITourRepository repository;
  const AddTourSeriesUseCase(this.repository);

  /// Her kalkış tarihi için ayrı döküman yaratır; ortak seriesId taşırlar.
  /// Donen `List<String>` olusturulan dokuman ID'lerini icerir.
  Future<Either<Failure, List<String>>> call(TourEntity tour) => repository.addTourSeries(tour);
}
