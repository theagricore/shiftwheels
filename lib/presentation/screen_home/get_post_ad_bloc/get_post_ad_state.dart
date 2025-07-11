part of 'get_post_ad_bloc.dart';

sealed class GetPostAdState extends Equatable {
  const GetPostAdState();

  @override
  List<Object> get props => [];
}

final class GetPostAdInitial extends GetPostAdState {}

final class GetPostAdLoading extends GetPostAdState {
  final List<AdWithUserModel>? previousAds;
  final List<AdWithUserModel>? previousPremiumAds;
  final String? selectedBrand;

  const GetPostAdLoading({
    this.previousAds,
    this.previousPremiumAds,
    this.selectedBrand,
  });

  @override
  List<Object> get props => [previousAds ?? [], previousPremiumAds ?? [], selectedBrand ?? ''];
}

final class GetPostAdLoaded extends GetPostAdState {
  final List<AdWithUserModel> ads;
  final List<AdWithUserModel> premiumAds;
  final String? selectedBrand;

  const GetPostAdLoaded(this.ads, {required this.premiumAds, this.selectedBrand});

  @override
  List<Object> get props => [ads, premiumAds, selectedBrand ?? ''];
}

final class GetPostAdError extends GetPostAdState {
  final String message;

  const GetPostAdError(this.message);

  @override
  List<Object> get props => [message];
}