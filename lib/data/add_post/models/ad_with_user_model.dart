import 'package:shiftwheels/data/add_post/models/ads_model.dart';

class AdWithUserModel {
  final AdsModel ad;
  final Map<String, dynamic>? userData;
  
  AdWithUserModel({
    required this.ad,
    this.userData,
  });
}
