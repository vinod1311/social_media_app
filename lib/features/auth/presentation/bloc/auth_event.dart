import 'package:flutter/cupertino.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent{
  final String email;
  final String password;
  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent{
  final String email;
  final String password;
  SignUpEvent(this.email, this.password);
}

class CheckAuthStatusEvent extends AuthEvent{}

class SignOutEvent extends AuthEvent {
  BuildContext context;
  SignOutEvent(this.context);
}