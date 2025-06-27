part of 'profile_image_bloc.dart';

sealed class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object> get props => [];
}

final class ProfileImageInitial extends ProfileImageState {}

final class ProfileImagePicked extends ProfileImageState {
  final File image;

  const ProfileImagePicked(this.image);

  @override
  List<Object> get props => [image];
}

final class ProfileImageConfirmed extends ProfileImageState {
  final File image;

  const ProfileImageConfirmed(this.image);

  @override
  List<Object> get props => [image];
}

final class ProfileImageError extends ProfileImageState {
  final String message;

  const ProfileImageError(this.message);

  @override
  List<Object> get props => [message];
}
