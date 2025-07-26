part of 'mark_as_sold_bloc.dart';

abstract class MarkAsSoldState extends Equatable {
  const MarkAsSoldState();

  @override
  List<Object> get props => [];
}

class MarkAsSoldInitial extends MarkAsSoldState {}

class MarkAsSoldLoading extends MarkAsSoldState {}

class MarkAsSoldSuccess extends MarkAsSoldState {}

class MarkAsSoldError extends MarkAsSoldState {
  final String message;

  const MarkAsSoldError(this.message);

  @override
  List<Object> get props => [message];
}