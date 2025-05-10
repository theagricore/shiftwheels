part of 'google_auth_bloc.dart';

@immutable
sealed class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final String message;
  GoogleAuthSuccess(this.message);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String errorMessage;
  GoogleAuthFailure(this.errorMessage);
}