import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class AdWithUserModel {
  final AdsModel ad;
  final UserModel? userData; 
  final bool isFavorite;
  
  AdWithUserModel({
    required this.ad,
     this.userData, 
    this.isFavorite = false,
  });
}