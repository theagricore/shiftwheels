// ad_with_user_model.dart
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class AdWithUserModel {
  final AdsModel ad;
  final UserModel? userData; // Add user field
  final bool isFavorite;
  
  AdWithUserModel({
    required this.ad,
     this.userData, // Make it required
    this.isFavorite = false,
  });
}