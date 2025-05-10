part of 'add_post_bloc.dart';

@immutable
sealed class AddPostEvent {}

class InitializeBrandsEvent extends AddPostEvent {}
class InitializeFuelsEvent extends AddPostEvent {}

class FetchBrandsEvent extends AddPostEvent {}

class FetchModelsEvent extends AddPostEvent {
  final String brandId;

  FetchModelsEvent(this.brandId);
}

class FetchFuelsEvent extends AddPostEvent {}