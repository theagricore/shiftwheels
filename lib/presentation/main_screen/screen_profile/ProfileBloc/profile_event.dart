// profile_event.dart
part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class FetchUserProfile extends ProfileEvent {}
