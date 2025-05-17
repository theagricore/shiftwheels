import 'package:equatable/equatable.dart';

abstract class SeatTypeState extends Equatable {
  final int seatCount;
  const SeatTypeState(this.seatCount);

  @override
  List<Object> get props => [seatCount];
}

class SeatTypeInitial extends SeatTypeState {
  const SeatTypeInitial(int seatCount) : super(seatCount);
}

class SeatTypeChanged extends SeatTypeState {
  const SeatTypeChanged(int seatCount) : super(seatCount);
}
