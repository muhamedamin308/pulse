import 'package:injectable/injectable.dart';
import 'package:pulse/features/auth/domain/entities/user_entity.dart';
import 'package:pulse/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GetCurrentUserUsecase {
  final AuthRepository _authRepository;

  GetCurrentUserUsecase(this._authRepository);

  Future<UserEntity?> execute() async {
    return await _authRepository.getCurrentUser();
  }
}
