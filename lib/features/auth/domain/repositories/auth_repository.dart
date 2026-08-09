import 'package:pulse/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}
