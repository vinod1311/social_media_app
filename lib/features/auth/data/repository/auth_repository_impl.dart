

import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository{
  final FirebaseAuthDataSource _firebaseAuthDataSource;

  AuthRepositoryImpl(this._firebaseAuthDataSource);
  @override
  Future<UserEntity?> getCurrentUser() {
    return _firebaseAuthDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password) async{
    return await _firebaseAuthDataSource.signIn(email, password);
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword(String email, String password)async {
    return await _firebaseAuthDataSource.signUp(email, password);
  }

  @override
  Future<void> singOut() async {
    await _firebaseAuthDataSource.signOut();
  }

}