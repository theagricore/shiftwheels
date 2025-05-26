part of 'active_ads_bloc.dart';

abstract class ActiveAdsEvent extends Equatable {
  const ActiveAdsEvent();

  @override
  List<Object> get props => [];
}

class LoadActiveAds extends ActiveAdsEvent {
  final String userId;
  
  const LoadActiveAds(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeactivateAd extends ActiveAdsEvent {
  final String adId;
  
  const DeactivateAd(this.adId);

  @override
  List<Object> get props => [adId];
}
