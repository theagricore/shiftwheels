part of 'mark_as_sold_bloc.dart';

abstract class MarkAsSoldEvent extends Equatable {
  const MarkAsSoldEvent();

  @override
  List<Object> get props => [];
}

class MarkAdAsSoldEvent extends MarkAsSoldEvent {
  final String adId;

  const MarkAdAsSoldEvent(this.adId);

  @override
  List<Object> get props => [adId];
}