part of 'profile_image_bloc.dart';

sealed class ProfileImageEvent extends Equatable {
  const ProfileImageEvent();

  @override
  List<Object> get props => [];
}

class PickProfileImageEvent extends ProfileImageEvent {
  final ImageSource source;

  const PickProfileImageEvent({this.source = ImageSource.gallery});

  @override
  List<Object> get props => [source];
}

class ConfirmProfileImageEvent extends ProfileImageEvent {
  final File image;

  const ConfirmProfileImageEvent(this.image);

  @override
  List<Object> get props => [image];
}