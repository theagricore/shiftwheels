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
  final String? selectedBrand;

  const RefreshActiveAds({this.selectedBrand});

  @override
  List<Object> get props => [selectedBrand ?? ''];
}

class FilterByBrandEvent extends GetPostAdEvent {
  final String brandName;

  const FilterByBrandEvent(this.brandName);

  @override
  List<Object> get props => [brandName];
}