import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../repositories/i_tour_repository.dart';

class GetCompaniesUseCase {
  final ITourRepository repository;
  const GetCompaniesUseCase(this.repository);

  Future<Either<Failure, List<CompanyEntity>>> call() => repository.getCompanies();
}
