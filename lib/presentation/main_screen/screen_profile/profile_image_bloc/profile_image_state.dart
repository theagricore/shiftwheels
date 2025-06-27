part of 'profile_image_bloc.dart';

sealed class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object> get props => [];
}

final class ProfileImageInitial extends ProfileImageState {}

final class ProfileImageLoading extends ProfileImageState {}

final class ProfileImagePicked extends ProfileImageState {
  final File image;

  const ProfileImagePicked(this.image);

  @override
  List<Object> get props => [image];
}

final class ProfileImageConfirmed extends ProfileImageState {
  final String imageUrl;

  const ProfileImageConfirmed({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

final class ProfileImageError extends ProfileImageState {
  final String message;

  const ProfileImageError(this.message);

  @override
  List<Object> get props => [message];
}