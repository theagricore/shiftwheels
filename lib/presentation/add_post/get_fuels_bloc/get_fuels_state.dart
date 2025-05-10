
part of 'get_fuels_bloc.dart';

@immutable
sealed class GetFuelsState {}

final class GetFuelsInitial extends GetFuelsState {}

class GetFuelsLoading extends GetFuelsState {}

class GetFuelsLoaded extends GetFuelsState {
  final List<FuelsModel> fuels;

  GetFuelsLoaded(this.fuels);
}

class GetFuelsError extends GetFuelsState {
  final String message;

  GetFuelsError(this.message);
}