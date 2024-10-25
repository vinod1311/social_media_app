
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class FirebaseAuthDataSource{

  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<UserModel?> signIn(String email,String password)async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        return UserModel.fromFirebaseUser(userCredential.user);
      }
    }catch(e){
      log("----**ERROR**----- Getting Error from Firebase SignIn FirebaseAuthDataSource ${e.toString()}");
      rethrow;
    }

  }

  Future<UserModel?> signUp(String email,String password)async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        return UserModel.fromFirebaseUser(userCredential.user);
      }
    }catch(e){
      log("----**ERROR**----- Getting Error from Firebase SignUp FirebaseAuthDataSource ${e.toString()}");
      rethrow;
    }
  }

  Future<void> signOut()async{
    try{
      await _firebaseAuth.signOut();
    }catch(e){
      log("----**ERROR**----- Getting Error from Firebase SignOut FirebaseAuthDataSource ${e.toString()}");
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    try{
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    }catch(e){
      log("----**ERROR**----- Getting Error from Firebase SignOut FirebaseAuthDataSource");
      rethrow;
    }
  }


}