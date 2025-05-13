import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_location_usecase.dart';

part 'get_location_event.dart';
part 'get_location_state.dart';

class GetLocationBloc extends Bloc<GetLocationEvent, GetLocationState> {
  final GetLocationUsecase getLocationUsecase;

  GetLocationBloc({required this.getLocationUsecase})
    : super(GetLocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<GetLocationState> emit,
  ) async {
    emit(GetLocationLoading());
    final result = await getLocationUsecase();
    result.fold(
      (error) => emit(GetLocationError(error)),
      (location) => emit(GetLocationSuccess(location)),
    );
  }
}
