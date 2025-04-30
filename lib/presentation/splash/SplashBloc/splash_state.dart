part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class DisplaySplash extends SplashState {}

final class Authenticated extends SplashState {}

final class UnAuthenticated extends SplashState {}
