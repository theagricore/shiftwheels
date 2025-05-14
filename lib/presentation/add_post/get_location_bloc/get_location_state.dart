
part of 'get_location_bloc.dart';

@immutable
sealed class GetLocationState {}

final class GetLocationInitial extends GetLocationState {}

final class GetLocationLoading extends GetLocationState {}

final class GetLocationSuccess extends GetLocationState {
  final LocationModel location;

  GetLocationSuccess(this.location);
}

final class GetLocationError extends GetLocationState {
  final String message;

  GetLocationError(this.message);
}

final class GetLocationSearchResults extends GetLocationState {
  final List<LocationModel> locations;

  GetLocationSearchResults(this.locations);
}
final class LocationSelectedState extends GetLocationState {
  final LocationModel location;

  LocationSelectedState(this.location);
}
final class GetLocationSearchSelected extends GetLocationState {
  final LocationModel location;

  GetLocationSearchSelected(this.location);
}