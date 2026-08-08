import 'package:injectable/injectable.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pulse/features/auth/domain/entities/user_entity.dart';
import 'package:pulse/features/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final userModel = await _remoteDataSource.signInWithGoogle();
      return userModel.toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
      (userModel) => userModel?.toEntity(),
    );
  }
}
