import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_company_repository.dart';

class SetCompanyStatusParams {
  final String companyId;
  final bool isActive;

  const SetCompanyStatusParams({required this.companyId, required this.isActive});
}

class SetCompanyStatusUseCase {
  final ICompanyRepository repository;

  const SetCompanyStatusUseCase(this.repository);

  Future<Either<Failure, Unit>> call(SetCompanyStatusParams params) {
    return repository.setCompanyStatus(params.companyId, isActive: params.isActive);
  }
}
