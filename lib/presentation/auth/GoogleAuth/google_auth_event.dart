part of 'google_auth_bloc.dart';

@immutable
sealed class GoogleAuthEvent {}

class GoogleSignInRequested extends GoogleAuthEvent {}