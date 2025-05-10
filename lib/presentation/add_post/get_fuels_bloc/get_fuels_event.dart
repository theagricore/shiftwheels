part of 'get_fuels_bloc.dart';

@immutable
sealed class GetFuelsEvent {}

class FetchFuels extends GetFuelsEvent {}