part of 'seat_type_bloc.dart';

abstract class SeatTypeEvent extends Equatable {
  const SeatTypeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTransmissionTypeEvent extends SeatTypeEvent {
  final String transmissionType;

  const ChangeTransmissionTypeEvent(this.transmissionType);

  @override
  List<Object> get props => [transmissionType];
}