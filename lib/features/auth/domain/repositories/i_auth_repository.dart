import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepository {
  /// E-posta ve şifre ile giriş yapar.
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password});

  /// Yeni kullanıcı kaydı oluşturur.
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  /// Oturumu kapatır.
  Future<Either<Failure, Unit>> signOut();

  /// Mevcut oturumdaki kullanıcıyı döndürür; oturum yoksa null döner.
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
