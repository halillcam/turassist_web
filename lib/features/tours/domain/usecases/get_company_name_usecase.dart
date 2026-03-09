import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_tour_repository.dart';

class GetCompanyNameUseCase {
  final ITourRepository repository;
  const GetCompanyNameUseCase(this.repository);

  Future<Either<Failure, String>> call(String companyId) => repository.getCompanyName(companyId);
}
