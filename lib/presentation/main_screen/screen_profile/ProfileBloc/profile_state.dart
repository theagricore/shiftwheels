part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class Profileloading extends ProfileState {}

final class Profileloaded extends ProfileState {
  final GetUserEntity user;
  Profileloaded({required this.user});
}

final class ProfileInfoFailure extends ProfileState {
  final String? message;
  ProfileInfoFailure({this.message});
}
