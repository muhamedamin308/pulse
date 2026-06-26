import 'package:pulse/features/auth/domain/entities/user_entity.dart';
import 'package:pulse/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );
  }
}
