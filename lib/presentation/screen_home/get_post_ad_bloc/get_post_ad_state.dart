part of 'get_post_ad_bloc.dart';

sealed class GetPostAdState extends Equatable {
  const GetPostAdState();

  @override
  List<Object> get props => [];
}

final class GetPostAdInitial extends GetPostAdState {}

final class GetPostAdLoading extends GetPostAdState {
  final List<AdWithUserModel>? previousAds;

  const GetPostAdLoading({this.previousAds});

  @override
  List<Object> get props => [previousAds ?? []];
}

final class GetPostAdLoaded extends GetPostAdState {
  final List<AdWithUserModel> ads;
  final String? selectedBrand;

  const GetPostAdLoaded(this.ads, {this.selectedBrand});

  @override
  List<Object> get props => [ads, selectedBrand ?? ''];
}

final class GetPostAdError extends GetPostAdState {
  final String message;

  const GetPostAdError(this.message);

  @override
  List<Object> get props => [message];
}