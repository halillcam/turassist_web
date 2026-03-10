import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/company_entity.dart';

abstract class ICompanyRepository {
  Stream<Either<Failure, List<CompanyEntity>>> watchCompanies({required bool isActive});
  Future<Either<Failure, CompanyEntity?>> getCompany(String companyId);
  Future<Either<Failure, Unit>> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String city = '',
    String logo = '',
  });
  Future<Either<Failure, Unit>> updateCompany(String companyId, Map<String, dynamic> data);
  Future<Either<Failure, Unit>> setCompanyStatus(String companyId, {required bool isActive});
}
