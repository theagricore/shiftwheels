part of 'get_post_ad_bloc.dart';

sealed class GetPostAdEvent extends Equatable {
  const GetPostAdEvent();
  
  @override
  List<Object> get props => [];
}

class FetchActiveAds extends GetPostAdEvent {
  const FetchActiveAds();
}

class RefreshActiveAds extends GetPostAdEvent {
  const RefreshActiveAds();
}