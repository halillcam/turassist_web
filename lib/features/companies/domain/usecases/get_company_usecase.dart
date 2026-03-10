import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/company_entity.dart';
import '../repositories/i_company_repository.dart';

class GetCompanyUseCase {
  final ICompanyRepository repository;

  const GetCompanyUseCase(this.repository);

  Future<Either<Failure, CompanyEntity?>> call(String companyId) =>
      repository.getCompany(companyId);
}
