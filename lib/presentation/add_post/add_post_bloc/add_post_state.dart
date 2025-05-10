// add_post_state.dart (updated)
part of 'add_post_bloc.dart';

@immutable
sealed class AddPostState {}

final class AddPostInitial extends AddPostState {}

class BrandsLoading extends AddPostState {
  final List<BrandModel>? previousBrands;

  BrandsLoading({this.previousBrands});
}

class BrandsLoaded extends AddPostState {
  final List<BrandModel> brands;

  BrandsLoaded(this.brands);
}

class BrandsError extends AddPostState {
  final String message;

  BrandsError(this.message);
}

class ModelsLoading extends AddPostState {
  final List<String>? previousModels;

  ModelsLoading({this.previousModels});
}

class ModelsLoaded extends AddPostState {
  final List<String> models;

  ModelsLoaded(this.models);
}

class ModelsError extends AddPostState {
  final String message;

  ModelsError(this.message);
}