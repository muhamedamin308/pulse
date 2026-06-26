import 'package:pulse/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase(this._authRepository);

  Future<void> execute() async {
    return await _authRepository.signOut();
  }
}
