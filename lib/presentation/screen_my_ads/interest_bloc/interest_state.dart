part of 'interest_bloc.dart';

abstract class InterestState extends Equatable {
  const InterestState();

  @override
  List<Object> get props => [];
}

class InterestInitial extends InterestState {}

class InterestLoading extends InterestState {}

class InterestError extends InterestState {
  final String message;

  const InterestError(this.message);

  @override
  List<Object> get props => [message];
}

class InterestToggled extends InterestState {
  final String adId;
  final bool isNowInterested;

  const InterestToggled({
    required this.adId,
    required this.isNowInterested,
  });

  @override
  List<Object> get props => [adId, isNowInterested];
}

class InitialInterestLoaded extends InterestState {
  final bool isInterested;
  final String adId;

  const InitialInterestLoaded({
    required this.isInterested,
    required this.adId,
  });

  @override
  List<Object> get props => [isInterested, adId];
}