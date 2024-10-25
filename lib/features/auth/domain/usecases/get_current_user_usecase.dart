

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  Future<UserEntity?> call(){
    return authRepository.getCurrentUser();
  }
}