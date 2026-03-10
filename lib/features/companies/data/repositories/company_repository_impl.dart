import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/i_company_repository.dart';
import '../datasources/company_remote_data_source.dart';
import '../models/company_dto.dart';

class CompanyRepositoryImpl implements ICompanyRepository {
  final ICompanyRemoteDataSource _remoteDataSource;

  const CompanyRepositoryImpl(this._remoteDataSource);

  @override
  Stream<Either<Failure, List<CompanyEntity>>> watchCompanies({required bool isActive}) {
    return _remoteDataSource
        .watchCompanies(isActive: isActive)
        .map(
          (list) => Right<Failure, List<CompanyEntity>>(list.map((dto) => dto.toEntity()).toList()),
        )
        .handleError((error) => Left(ServerFailure(error.toString())));
  }

  @override
  Future<Either<Failure, CompanyEntity?>> getCompany(String companyId) async {
    try {
      final dto = await _remoteDataSource.getCompany(companyId);
      return Right(dto?.toEntity());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addCompany({
    required String companyName,
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String city = '',
    String logo = '',
  }) async {
    try {
      await _remoteDataSource.addCompany(
        AddCompanyRemotePayload(
          companyName: companyName,
          fullName: fullName,
          phone: phone,
          email: email,
          password: password,
          city: city,
          logo: logo,
        ),
      );
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCompany(String companyId, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updateCompany(companyId, data);
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCompanyStatus(String companyId, {required bool isActive}) async {
    try {
      await _remoteDataSource.setCompanyStatus(companyId, isActive: isActive);
      return const Right(unit);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
