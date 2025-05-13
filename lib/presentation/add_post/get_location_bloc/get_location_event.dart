part of 'get_location_bloc.dart';

@immutable
sealed class GetLocationEvent {}

class GetCurrentLocationEvent extends GetLocationEvent {}


