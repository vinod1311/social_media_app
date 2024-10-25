
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase{

  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<UserEntity?> call(String email,String password){
    return authRepository.signUpWithEmailAndPassword(email, password);
  }

}