// post_ad_state.dart
part of 'post_ad_bloc.dart';

abstract class PostAdState extends Equatable {
  const PostAdState();

  @override
  List<Object> get props => [];
}

class PostAdInitial extends PostAdState {}

class PostAdLoading extends PostAdState {}

class PostAdSuccess extends PostAdState {
  final String adId;

  const PostAdSuccess(this.adId);

  @override
  List<Object> get props => [adId];
}

class PostAdError extends PostAdState {
  final String message;

  const PostAdError(this.message);

  @override
  List<Object> get props => [message];
}

class PostLimitChecked extends PostAdState {
  final UserPostLimit limit;

  const PostLimitChecked(this.limit);

  @override
  List<Object> get props => [limit];
}

class PostLimitReached extends PostAdState {
  final UserPostLimit limit;

  const PostLimitReached(this.limit);

  @override
  List<Object> get props => [limit];
}