import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_company_repository.dart';

class UpdateCompanyParams {
  final String companyId;
  final Map<String, dynamic> data;

  const UpdateCompanyParams({required this.companyId, required this.data});
}

class UpdateCompanyUseCase {
  final ICompanyRepository repository;

  const UpdateCompanyUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UpdateCompanyParams params) {
    return repository.updateCompany(params.companyId, params.data);
  }
}
