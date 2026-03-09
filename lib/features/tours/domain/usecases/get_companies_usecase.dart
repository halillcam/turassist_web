import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/company_model.dart';
import '../repositories/i_tour_repository.dart';

class GetCompaniesUseCase {
  final ITourRepository repository;
  const GetCompaniesUseCase(this.repository);

  Future<Either<Failure, List<CompanyModel>>> call() => repository.getCompanies();
}
