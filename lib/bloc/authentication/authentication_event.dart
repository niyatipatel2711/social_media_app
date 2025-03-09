import 'package:flutter/material.dart';
import '../../modules/login/login_screen.dart';
import '../../modules/sign_up/sign_up_screen.dart';

abstract class AuthEvent {}

@immutable
class LoginEvent extends AuthEvent{
  final LoginParams loginParams;

  LoginEvent({required this.loginParams});
}

class SignUpEvent extends AuthEvent{
  final SignUpParams signUpParams;

  SignUpEvent({required this.signUpParams});
}
