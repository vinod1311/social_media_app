import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_medial_app/core/utils/shared_prefrence_helper.dart';
import 'package:social_medial_app/features/auth/presentation/screens/sign_in_screen.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
        required this.signInUseCase,
        required this.signUpUseCase,
        required this.signOutUseCase,
        required this.getCurrentUserUseCase
      }):super(AuthInitial()){
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  //----------- Sign in Method
  Future<void> _onSignIn(SignInEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await signInUseCase.call(event.email, event.password);
      if(user != null){
        SharedPreferencesHelper.setUserName(user.email);
        SharedPreferencesHelper.setUserId(user.uid);
        SharedPreferencesHelper.setIsUserLoggedIn(true);
        emit(Authenticated(user));
      }else{
        SharedPreferencesHelper.setIsUserLoggedIn(false);
        emit(AuthError("Sign in failed"));
      }
    }catch(e){
      SharedPreferencesHelper.setIsUserLoggedIn(false);
      emit(AuthError(e.toString()));
    }
  }

  //------------ Sign up method
  Future<void> _onSignUp(SignUpEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());

    try{
      final user = await signUpUseCase.call(event.email, event.password);
      if(user != null){
        SharedPreferencesHelper.setIsUserLoggedIn(true);
        SharedPreferencesHelper.setUserName(user.email);
        SharedPreferencesHelper.setUserId(user.uid);
        emit(Authenticated(user));
      }else{
        SharedPreferencesHelper.setIsUserLoggedIn(false);
        emit(AuthError("Sign up failed"));
      }
    }catch(e){
      SharedPreferencesHelper.setIsUserLoggedIn(false);
      emit(AuthError(e.toString()));
    }
  }

  //---------- Sign out method
  Future<void> _onSignOut(SignOutEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      await signOutUseCase.call();
      emit(Unauthenticated());
      SharedPreferencesHelper.clearSharedPreference();
      // Redirect to the login screen
      Navigator.of(event.context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }catch(e){
      emit(AuthError(e.toString()));
    }
  }

  //--------- Method for checking user is logged in or not
  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await  getCurrentUserUseCase.call();
      if(user != null){
        SharedPreferencesHelper.setIsUserLoggedIn(true);
        SharedPreferencesHelper.setUserName(user.email);
        SharedPreferencesHelper.setUserId(user.uid);
        emit(Authenticated(user));
      }else{
        SharedPreferencesHelper.setIsUserLoggedIn(false);
        emit(Unauthenticated());
      }
    }catch(e){
      SharedPreferencesHelper.setIsUserLoggedIn(false);
      emit(AuthError(e.toString()));
    }
  }
}