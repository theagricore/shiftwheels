import 'package:shiftwheels/data/add_post/models/ads_model.dart';

class AdWithUserModel {
  final AdsModel ad;
  final Map<String, dynamic>? userData;
  final bool isFavorite;
  
  AdWithUserModel({
    required this.ad,
    this.userData,
    this.isFavorite = false,
  });
}