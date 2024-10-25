

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserEntity?> call(String email,String password){
    return authRepository.signInWithEmailAndPassword(email, password);
  }

}