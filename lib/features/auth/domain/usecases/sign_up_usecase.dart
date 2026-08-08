import 'package:injectable/injectable.dart';
import 'package:pulse/features/auth/domain/entities/user_entity.dart';
import 'package:pulse/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<UserEntity> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.signUpWithEmail(
      name: name,
      email: email,
      password: password,
    );
  }
}
