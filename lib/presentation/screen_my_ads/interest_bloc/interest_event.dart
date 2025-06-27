part of 'interest_bloc.dart';

abstract class InterestEvent extends Equatable {
  const InterestEvent();

  @override
  List<Object> get props => [];
}

class ToggleInterestEvent extends InterestEvent {
  final String adId;
  final String userId;
  final bool currentStatus;

  const ToggleInterestEvent(this.adId, this.userId, this.currentStatus);

  @override
  List<Object> get props => [adId, userId, currentStatus];
}

class LoadInitialInterestEvent extends InterestEvent {
  final String adId;
  final String userId;

  const LoadInitialInterestEvent(this.adId, this.userId);

  @override
  List<Object> get props => [adId, userId];
}