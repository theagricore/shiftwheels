// call_state.dart
part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();
  
  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}

final class CallLoading extends CallState {}

final class CallSuccess extends CallState {}

final class CallFailure extends CallState {
  final String message;

  const CallFailure(this.message);

  @override
  List<Object> get props => [message];
}