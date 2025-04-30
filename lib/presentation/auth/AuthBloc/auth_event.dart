part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final UserModel user;
  SignUpEvent({required this.user});
}

class SignInEvent extends AuthEvent{

   final UserSiginModel userSiginModel;
  SignInEvent({required this.userSiginModel});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent({required this.email});
}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
