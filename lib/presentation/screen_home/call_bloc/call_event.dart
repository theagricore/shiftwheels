// call_event.dart
part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object> get props => [];
}

class MakePhoneCall extends CallEvent {
  final String phoneNumber;

  const MakePhoneCall(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}