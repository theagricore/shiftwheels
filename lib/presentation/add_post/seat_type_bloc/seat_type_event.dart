part of 'seat_type_bloc.dart';

abstract class SeatTypeEvent extends Equatable {
  const SeatTypeEvent();

  @override
  List<Object> get props => [];
}

class ChangeSeatTypeEvent extends SeatTypeEvent {
  final int seatCount;

  const ChangeSeatTypeEvent(this.seatCount);

  @override
  List<Object> get props => [seatCount];
}
