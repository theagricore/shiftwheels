part of 'get_images_bloc.dart';

abstract class GetImagesEvent extends Equatable {
  const GetImagesEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends GetImagesEvent {}

class RemoveImageEvent extends GetImagesEvent {
  final int index;

  const RemoveImageEvent(this.index);

  @override
  List<Object> get props => [index];
}

class SetInitialImages extends GetImagesEvent {
  final List<String> initialImages;

  const SetInitialImages(this.initialImages);

  @override
  List<Object> get props => [initialImages];
}