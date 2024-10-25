

import 'package:firebase_auth/firebase_auth.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository{

  Future<UserEntity?> signInWithEmailAndPassword(String email,String password);

  Future<UserEntity?> signUpWithEmailAndPassword(String email,String password);

  Future<void> singOut();

  Future<UserEntity?> getCurrentUser();

}