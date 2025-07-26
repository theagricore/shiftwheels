import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/domain/add_post/usecase/mark_as_sold_usecase.dart';

part 'mark_as_sold_event.dart';
part 'mark_as_sold_state.dart';

class MarkAsSoldBloc extends Bloc<MarkAsSoldEvent, MarkAsSoldState> {
  final MarkAsSoldUsecase markAsSoldUsecase;

  MarkAsSoldBloc(this.markAsSoldUsecase) : super(MarkAsSoldInitial()) {
    on<MarkAdAsSoldEvent>(_onMarkAdAsSold);
  }

  Future<void> _onMarkAdAsSold(
    MarkAdAsSoldEvent event,
    Emitter<MarkAsSoldState> emit,
  ) async {
    emit(MarkAsSoldLoading());
    final result = await markAsSoldUsecase(param: event.adId);
    result.fold(
      (error) => emit(MarkAsSoldError(error)),
      (_) => emit(MarkAsSoldSuccess()),
    );
  }
}