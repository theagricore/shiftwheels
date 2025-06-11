import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/data_source/firebase_post_service.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
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
Future<Either<String, String>> createChat(String adId, String buyerId, String sellerId) async {
  return await sl<FirebasePostService>().createChat(adId, buyerId, sellerId);
}

@override
Future<Either<String, List<ChatModel>>> getUserChats(String userId) async {
  return await sl<FirebasePostService>().getUserChats(userId);
}

@override
Future<Either<String, Stream<List<MessageModel>>>> getChatMessages(String chatId) async {
  return await sl<FirebasePostService>().getChatMessages(chatId);
}

@override
Future<Either<String, void>> sendMessage(String chatId, String senderId, String content) async {
  return await sl<FirebasePostService>().sendMessage(chatId, senderId, content);
}

@override
Future<Either<String, void>> markMessagesAsRead(String chatId, String userId) async {
  return await sl<FirebasePostService>().markMessagesAsRead(chatId, userId);
}
  
}
