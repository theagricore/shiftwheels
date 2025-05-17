part of 'get_images_bloc.dart';

abstract class GetImagesState extends Equatable {
  const GetImagesState();

  @override
  List<Object> get props => [];
}

class GetImagesInitial extends GetImagesState {}

class GetImagesLoading extends GetImagesState {}

class ImagesSelectedState extends GetImagesState {
  final List<String> imagePaths;

  const ImagesSelectedState({required this.imagePaths});

  @override
  List<Object> get props => [imagePaths];
}

class GetImagesError extends GetImagesState {
  final String message;

  const GetImagesError(this.message);

  @override
  List<Object> get props => [message];
}