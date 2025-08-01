part of 'post_limit_bloc.dart';

abstract class PostLimitState extends Equatable {
  const PostLimitState();

  @override
  List<Object> get props => [];
}

class PostLimitInitial extends PostLimitState {}

class PostLimitLoading extends PostLimitState {}

class PostLimitChecked extends PostLimitState {
  final UserPostLimit limit;

  const PostLimitChecked(this.limit);

  @override
  List<Object> get props => [limit];
}

class PostLimitError extends PostLimitState {
  final String message;

  const PostLimitError(this.message);

  @override
  List<Object> get props => [message];
}