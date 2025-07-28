import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class AdWithUserModel {
  final AdsModel ad;
  final UserModel? userData;
  final bool isFavorite;
  final bool isInterested;
  final bool isPremium;
  final double? distanceKm;

  AdWithUserModel({
    required this.ad,
    this.userData,
    this.isFavorite = false,
    this.isInterested = false,
    this.isPremium = false,
    this.distanceKm,
  });

  AdWithUserModel copyWith({
    AdsModel? ad,
    UserModel? userData,
    bool? isFavorite,
    bool? isInterested,
    bool? isPremium,
    double? distanceKm,
  }) {
    return AdWithUserModel(
      ad: ad ?? this.ad,
      userData: userData ?? this.userData,
      isFavorite: isFavorite ?? this.isFavorite,
      isInterested: isInterested ?? this.isInterested,
      isPremium: isPremium ?? this.isPremium,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}