part of 'get_location_bloc.dart';

@immutable
sealed class GetLocationEvent {}

class GetCurrentLocationEvent extends GetLocationEvent {}

class SearchLocationEvent extends GetLocationEvent {
  final String query;

  SearchLocationEvent(this.query);
}
class LocationSelectedEvent extends GetLocationEvent {
  final LocationModel location;

  LocationSelectedEvent(this.location);
}
