
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

