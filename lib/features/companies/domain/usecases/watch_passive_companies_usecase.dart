import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/company_entity.dart';
import '../repositories/i_company_repository.dart';

class WatchPassiveCompaniesUseCase {
  final ICompanyRepository repository;

  const WatchPassiveCompaniesUseCase(this.repository);

  Stream<Either<Failure, List<CompanyEntity>>> call() => repository.watchCompanies(isActive: false);
}
