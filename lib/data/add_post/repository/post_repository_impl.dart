import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/data_source/firebase_post_service.dart';
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
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class PostRepositoryImpl extends PostRepository {
  @override
  Future<Either<String, List<BrandModel>>> getBrands() async {
    return await sl<FirebasePostService>().getBrands();
  }

  @override
  Future<Either<String, List<String>>> getModels(String brandId) async {
    if (brandId.isEmpty) {
      return Left('Brand ID cannot be empty');
    }

    final result = await sl<FirebasePostService>().getModels(brandId);

    return result.fold(
      (error) => Left(error),
      (models) =>
          models.isEmpty
              ? Left('No models found for this brand')
              : Right(models),
    );
  }

  @override
  Future<Either<String, List<FuelsModel>>> getFuel() async {
    return await sl<FirebasePostService>().getFuel();
  }

  @override
  Future<Either<String, LocationModel>> getCurrentLocation() async {
    return await sl<FirebasePostService>().getCurrentLocation();
  }

  @override
  Future<Either<String, List<LocationModel>>> searchLocation(
    String query,
  ) async {
    return await sl<FirebasePostService>().searchLocation(query);
  }

  @override
  Future<Either<String, String>> postAd(AdsModel ad) async {
    return await sl<FirebasePostService>().postAd(ad);
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers() async {
    return await sl<FirebasePostService>().getActiveAdsWithUsers();
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserFavorites(
    String userId,
  ) async {
    return await sl<FirebasePostService>().getUserFavorites(userId);
  }

  @override
  Future<Either<String, void>> toggleFavorite(
    String adId,
    String userId,
  ) async {
    return await sl<FirebasePostService>().toggleFavorite(adId, userId);
  }

  @override
  Future<Either<String, void>> deactivateAd(String adId) async {
    return await sl<FirebasePostService>().deactivateAd(adId);
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserActiveAds(
    String userId,
  ) async {
    return await sl<FirebasePostService>().getUserActiveAds(userId);
  }

  @override
  Future<Either<String, void>> updateAd(AdsModel ad) async {
    return await sl<FirebasePostService>().updateAd(ad);
  }

  @override
  Stream<List<ChatModel>> getChatsForUser(String userId) {
    return sl<FirebasePostService>().getChatsForUser(userId);
  }

  @override
  Stream<List<MessageModel>> getMessagesForChat(String chatId) {
    return sl<FirebasePostService>().getMessagesForChat(chatId);
  }

  @override
  Future<Either<String, String>> createChat({
    required String adId,
    required String sellerId,
    required String buyerId,
  }) async {
    return await sl<FirebasePostService>().createChat(
      adId: adId,
      sellerId: sellerId,
      buyerId: buyerId,
    );
  }

  @override
  Future<Either<String, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? replyToMessageId,
    String? replyToContent,
  }) async {
    return await sl<FirebasePostService>().sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      replyToMessageId: replyToMessageId,
      replyToContent: replyToContent,
    );
  }

  @override
  Future<Either<String, void>> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    return await sl<FirebasePostService>().markMessagesAsRead(
      chatId: chatId,
      userId: userId,
    );
  }

  @override
  Future<Either<String, void>> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    return await sl<FirebasePostService>().deleteMessage(
      chatId: chatId,
      messageId: messageId,
    );
  }

  @override
  Future<Either<String, List<UserModel>>> getInterestedUsers(
    String adId,
  ) async {
    return await sl<FirebasePostService>().getInterestedUsers(adId);
  }

  @override
  Future<Either<String, void>> toggleInterest(
    String adId,
    String userId,
  ) async {
    return await sl<FirebasePostService>().toggleInterest(adId, userId);
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserInterests(
    String userId,
  ) async {
    return await sl<FirebasePostService>().getUserInterests(userId);
  }
  @override
  Future<Either<String, UserPostLimit>> getUserPostLimit(String userId) async {
    return await sl<FirebasePostService>().getUserPostLimit(userId);
  }

  @override
  Future<Either<String, String>> createPaymentRecord(
    PaymentModel payment,
  ) async {
    return await sl<FirebasePostService>().createPaymentRecord(payment);
  }

  @override
  Future<Either<String, void>> updatePaymentStatus({
    required String paymentId,
    required String status,
    required String transactionId,
  }) async {
    return await sl<FirebasePostService>().updatePaymentStatus(
      paymentId: paymentId,
      status: status,
      transactionId: transactionId,
    );
  }

  @override
  Future<Either<String, void>> incrementPostCount(String userId) async {
    return await sl<FirebasePostService>().incrementPostCount(userId);
  }
  
  @override
  Future<Either<String, List<AdWithUserModel>>> getPremiumUserAds() async {
    return await sl<FirebasePostService>().getPremiumUserAds();
  }
}
