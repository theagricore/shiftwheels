import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/add_post/models/payment_model.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/data/add_post/models/comparison_model.dart';

abstract class PostRepository {
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
  Future<Either<String, LocationModel>> getCurrentLocation();
  Future<Either<String, List<LocationModel>>> searchLocation(String query);
  Future<Either<String, String>> postAd(AdsModel ad);
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers();
  Future<Either<String, void>> toggleFavorite(String adId, String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserFavorites(String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserActiveAds(String userId);
  Future<Either<String, void>> toggleInterest(String adId, String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserInterests(String userId);
  Future<Either<String, void>> deactivateAd(String adId);
  Future<Either<String, void>> updateAd(AdsModel ad);
  Stream<List<ChatModel>> getChatsForUser(String userId);
  Stream<List<MessageModel>> getMessagesForChat(String chatId);
  Future<Either<String, List<UserModel>>> getInterestedUsers(String adId);
  Future<Either<String, String>> createChat({
    required String adId,
    required String sellerId,
    required String buyerId,
  });
  Future<Either<String, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? replyToMessageId,
    String? replyToContent,
  });
  Future<Either<String, void>> markMessagesAsRead({
    required String chatId,
    required String userId,
  });
  Future<Either<String, void>> deleteMessage({
    required String chatId,
    required String messageId,
  });
  Future<Either<String, UserPostLimit>> getUserPostLimit(String userId);
  Future<Either<String, String>> createPaymentRecord(PaymentModel payment);
  Future<Either<String, void>> updatePaymentStatus({
    required String paymentId,
    required String status,
    required String transactionId,
  });
  Future<Either<String, void>> incrementPostCount(String userId);
  Future<Either<String, List<AdWithUserModel>>> getPremiumUserAds();
  Future<Either<String, void>> markAdAsSold(String adId);
  Future<Either<String, String>> saveComparison({
    required String userId,
    required List<String> carIds,
  });
  Future<Either<String, List<ComparisonModel>>> getSavedComparisons(
    String userId,
  );
  Future<Either<String, List<AdWithUserModel>>> getComparisonCars(
    List<String> carIds,
  );
  Future<Either<String, void>> deleteComparison(String comparisonId);
}
