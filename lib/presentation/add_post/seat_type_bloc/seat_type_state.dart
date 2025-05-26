import 'package:equatable/equatable.dart';

abstract class SeatTypeState extends Equatable {
  final String transmissionType;
  const SeatTypeState(this.transmissionType);

  @override
  List<Object> get props => [transmissionType];
}

class SeatTypeInitial extends SeatTypeState {
  const SeatTypeInitial() : super('Manual'); // Default to Manual
}

class TransmissionTypeChanged extends SeatTypeState {
  const TransmissionTypeChanged(String transmissionType) : super(transmissionType);
}