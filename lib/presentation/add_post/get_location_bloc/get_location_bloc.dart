import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/get_location_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/search_location_usecase.dart';

part 'get_location_event.dart';
part 'get_location_state.dart';

class GetLocationBloc extends Bloc<GetLocationEvent, GetLocationState> {
  final GetLocationUsecase getLocationUsecase;
  final SearchLocationUsecase searchLocationUsecase;

  GetLocationBloc({
    required this.getLocationUsecase,
    required this.searchLocationUsecase,
  }) : super(GetLocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SearchLocationEvent>(_onSearchLocation);
    on<LocationSelectedEvent>(_onLocationSelected);
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

  Future<void> _onSearchLocation(
    SearchLocationEvent event,
    Emitter<GetLocationState> emit,
  ) async {
    emit(GetLocationLoading());
    final result = await searchLocationUsecase(param: event.query);
    result.fold((error) {
      if (error.contains('No locations found') ||
          error.contains('Search query cannot be empty')) {
        emit(GetLocationError(error));
      } else {
        emit(GetLocationSearchResults([]));
      }
    }, (locations) => emit(GetLocationSearchResults(locations)));
  }

  Future<void> _onLocationSelected(
    LocationSelectedEvent event,
    Emitter<GetLocationState> emit,
  ) async {
    emit(GetLocationSearchSelected(event.location));
  }
}
