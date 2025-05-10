
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_fuels_usecase.dart';

part 'get_fuels_event.dart';
part 'get_fuels_state.dart';

class GetFuelsBloc extends Bloc<GetFuelsEvent, GetFuelsState> {
  final GetFuelsUsecase getFuelsUsecase;

  GetFuelsBloc({required this.getFuelsUsecase}) : super(GetFuelsInitial()) {
    on<FetchFuels>((event, emit) async {
      emit(GetFuelsLoading());
      final result = await getFuelsUsecase.call();
      result.fold(
        (failure) => emit(GetFuelsError(failure)),
        (fuels) => emit(GetFuelsLoaded(fuels)),
      );
    });
  }
}