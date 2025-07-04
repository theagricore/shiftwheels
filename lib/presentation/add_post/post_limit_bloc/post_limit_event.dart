// post_limit_event.dart
part of 'post_limit_bloc.dart';

abstract class PostLimitEvent extends Equatable {
  const PostLimitEvent();

  @override
  List<Object> get props => [];
}

class CheckPostLimitEvent extends PostLimitEvent {
  final String userId;

  const CheckPostLimitEvent(this.userId);

  @override
  List<Object> get props => [userId];
}