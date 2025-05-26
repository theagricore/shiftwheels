part of 'update_ad_bloc.dart';

sealed class UpdateAdEvent extends Equatable {
  const UpdateAdEvent();
  
  @override
  List<Object> get props => [];
}

class UpdateAd extends UpdateAdEvent {
  final AdsModel ad;
  
  const UpdateAd(this.ad);
  
  @override
  List<Object> get props => [ad];
}