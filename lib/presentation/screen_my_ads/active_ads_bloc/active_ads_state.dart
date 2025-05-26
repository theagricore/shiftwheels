part of 'active_ads_bloc.dart';

abstract class ActiveAdsState extends Equatable {
  const ActiveAdsState();

  @override
  List<Object> get props => [];
}

class ActiveAdsInitial extends ActiveAdsState {}

class ActiveAdsLoading extends ActiveAdsState {}

class ActiveAdsError extends ActiveAdsState {
  final String message;

  const ActiveAdsError(this.message);

  @override
  List<Object> get props => [message];
}

class ActiveAdsLoaded extends ActiveAdsState {
  final List<AdWithUserModel> ads;

  const ActiveAdsLoaded(this.ads);

  @override
  List<Object> get props => [ads];
}
