import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_company_repository.dart';

class AddCompanyParams {
  final String companyName;
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String city;
  final String logo;

  const AddCompanyParams({
    required this.companyName,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    this.city = '',
    this.logo = '',
  });
}

class AddCompanyUseCase {
  final ICompanyRepository repository;

  const AddCompanyUseCase(this.repository);

  Future<Either<Failure, Unit>> call(AddCompanyParams params) {
    return repository.addCompany(
      companyName: params.companyName,
      fullName: params.fullName,
      phone: params.phone,
      email: params.email,
      password: params.password,
      city: params.city,
      logo: params.logo,
    );
  }
}
