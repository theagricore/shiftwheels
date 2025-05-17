import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_state.dart';

part 'seat_type_event.dart';

class SeatTypeBloc extends Bloc<SeatTypeEvent, SeatTypeState> {
  SeatTypeBloc() : super(const SeatTypeInitial(5)) {
    on<ChangeSeatTypeEvent>((event, emit) {
      emit(SeatTypeChanged(event.seatCount));
    });
  }
}
