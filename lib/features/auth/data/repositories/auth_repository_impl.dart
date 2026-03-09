import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// [IAuthRepository] arayüzünün somut Firebase implementasyonu.
/// Firebase nesneleri bu sınıfın dışına asla çıkmaz.
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.signIn(email: email, password: password);
      return Right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseCode(e.code)));
    } catch (_) {
      return Left(const ServerFailure('Beklenmedik bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final model = await _dataSource.signUp(
        email: email,
        password: password,
        name: name,
        role: _mapRoleToString(role),
      );
      return Right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseCode(e.code)));
    } catch (_) {
      return Left(const ServerFailure('Beklenmedik bir hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } catch (_) {
      return Left(const ServerFailure('Çıkış yapılırken hata oluştu.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final model = await _dataSource.getCurrentUser();
      return Right(model?.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseCode(e.code)));
    } catch (_) {
      return Left(const ServerFailure('Kullanıcı bilgisi alınamadı.'));
    }
  }

  // ─── Yardımcılar ─────────────────────────────────────────────────────────

  String _mapFirebaseCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı.';
      case 'invalid-credential':
        return 'Geçersiz e-posta veya şifre.';
      case 'email-already-in-use':
        return 'Bu e-posta zaten kullanımda.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'network-request-failed':
        return 'İnternet bağlantısı yok.';
      default:
        return 'Kimlik doğrulama hatası: $code';
    }
  }

  String _mapRoleToString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.admin:
        return 'admin';
    }
  }
}
