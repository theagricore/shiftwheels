import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
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

abstract class FirebasePostService {
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
  Future<Either<String, LocationModel>> getCurrentLocation();
  Future<Either<String, List<LocationModel>>> searchLocation(String query);
  Future<Either<String, String>> postAd(AdsModel ad);
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers();
  Future<Either<String, void>> toggleFavorite(String adId, String userId);
  Future<Either<String, void>> toggleInterest(String adId, String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserInterests(String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserFavorites(String userId);
  Future<Either<String, List<AdWithUserModel>>> getUserActiveAds(String userId);
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
}

class PostFirebaseServiceImpl extends FirebasePostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loc.Location _location = loc.Location();

  @override
  Future<Either<String, List<BrandModel>>> getBrands() async {
    try {
      final snapshot = await _firestore.collection('Brands').get();
      final brands =
          snapshot.docs.map((doc) {
            return BrandModel(
              id: doc.id,
              brandName: doc['brandName'] as String? ?? '',
              image: doc['imageUrl'] as String?,
            );
          }).toList();

      if (brands.isEmpty) {
        return Left('No brands found');
      }
      return Right(brands);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<String>>> getModels(String brandId) async {
    try {
      final snapshot =
          await _firestore
              .collection('Brands')
              .doc(brandId)
              .collection('Models')
              .get();

      final models =
          snapshot.docs
              .map((doc) => doc['modelName'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();

      if (models.isEmpty) {
        return Left('No models found for this brand');
      }
      return Right(models);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<FuelsModel>>> getFuel() async {
    try {
      final snapshot = await _firestore.collection('fuels').get();
      final fuels =
          snapshot.docs.map((doc) {
            return FuelsModel(id: doc.id, fuels: doc['fuels'] as String? ?? '');
          }).toList();
      return Right(fuels);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, LocationModel>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return Left('Location services are disabled');
        }
      }

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          return Left('Location permissions are denied');
        }
      }

      final locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return Left('Failed to get valid location coordinates');
      }

      final placeDetails = await _getPlaceDetails(
        locationData.latitude!,
        locationData.longitude!,
      );

      return Right(
        LocationModel(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          placeName: placeDetails['placeName'],
          address: placeDetails['address'],
          city: placeDetails['city'],
          country: placeDetails['country'],
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == 'SERVICE_STATUS_ERROR') {
        return Left('Location services are disabled');
      } else if (e.code == 'PERMISSION_DENIED') {
        return Left('Location permissions are denied');
      }
      return Left('Failed to get location: ${e.message}');
    } catch (e) {
      return Left('Failed to get location: ${e.toString()}');
    }
  }

  Future<Map<String, String?>> _getPlaceDetails(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return {};

      final place = placemarks.first;
      return {
        'placeName': place.name,
        'address': _buildAddress(place),
        'city': place.locality ?? place.subAdministrativeArea,
        'country': place.country,
      };
    } catch (e) {
      print('Reverse geocoding error: $e');
      return {};
    }
  }

  String _buildAddress(Placemark place) {
    final addressParts =
        [
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ].where((part) => part != null && part.isNotEmpty).toList();

    return addressParts.join(', ');
  }

  @override
  Future<Either<String, List<LocationModel>>> searchLocation(
    String query,
  ) async {
    try {
      if (query.isEmpty) {
        return Left('Search query cannot be empty');
      }

      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        return Left('No locations found for "$query"');
      }

      final results = <LocationModel>[];
      for (final location in locations) {
        try {
          final placeDetails = await _getPlaceDetails(
            location.latitude,
            location.longitude,
          );

          results.add(
            LocationModel(
              latitude: location.latitude,
              longitude: location.longitude,
              placeName: placeDetails['placeName'] ?? 'Unknown place',
              address: placeDetails['address'] ?? query,
              city: placeDetails['city'],
              country: placeDetails['country'],
            ),
          );
        } catch (e) {
          results.add(
            LocationModel(
              latitude: location.latitude,
              longitude: location.longitude,
              address: query,
            ),
          );
          continue;
        }
      }

      if (results.isEmpty) {
        return Left('Found locations but couldn\'t get details');
      }
      return Right(results);
    } on PlatformException catch (e) {
      return Left('Location service error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      return Left('Failed to search location');
    }
  }

  @override
  Future<Either<String, String>> postAd(AdsModel ad) async {
    try {
      final docRef = await _firestore.collection("car_ads").add(ad.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers() async {
    try {
      final adsSnapshot =
          await _firestore
              .collection('car_ads')
              .where('isActive', isEqualTo: true)
              .get();

      final ads =
          adsSnapshot.docs
              .map((doc) => AdsModel.fromMap(doc.data(), doc.id))
              .toList();

      final result = <AdWithUserModel>[];

      for (final ad in ads) {
        try {
          final userDoc =
              await _firestore.collection('Users').doc(ad.userId).get();
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            final userModel = UserModel(
              fullName: userData['fullName'] as String?,
              email: userData['email'] as String?,
              phoneNo: userData['phoneNo'] as String?,
              uid: userData['uid'] as String?,
              createdAt: userData['createdAt']?.toString(),
              image: userData['image'] as String?,
            );

            result.add(AdWithUserModel(ad: ad, userData: userModel));
          } else {
            result.add(
              AdWithUserModel(ad: ad, userData: UserModel(uid: ad.userId)),
            );
          }
        } catch (e) {
          result.add(
            AdWithUserModel(ad: ad, userData: UserModel(uid: ad.userId)),
          );
          continue;
        }
      }

      return Right(result);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> toggleFavorite(
    String adId,
    String userId,
  ) async {
    try {
      final adRef = _firestore.collection('car_ads').doc(adId);

      await _firestore.runTransaction((transaction) async {
        final adDoc = await transaction.get(adRef);
        if (!adDoc.exists) {
          throw Exception('Ad not found');
        }

        final currentFavorites = List<String>.from(
          adDoc['favoritedByUsers'] ?? [],
        );
        final isFavorite = currentFavorites.contains(userId);

        if (isFavorite) {
          currentFavorites.remove(userId);
        } else {
          currentFavorites.add(userId);
        }

        transaction.update(adRef, {'favoritedByUsers': currentFavorites});
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to toggle favorite: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> toggleInterest(
    String adId,
    String userId,
  ) async {
    try {
      final adRef = _firestore.collection('car_ads').doc(adId);
      await _firestore.runTransaction((transaction) async {
        final adSnapshot = await transaction.get(adRef);
        if (!adSnapshot.exists) {
          throw Exception('Ad not found');
        }

        final adData = adSnapshot.data()!;
        final interestedUsers = List<String>.from(
          adData['interestedUsers'] ?? [],
        );

        if (interestedUsers.contains(userId)) {
          interestedUsers.remove(userId);
        } else {
          interestedUsers.add(userId);
        }

        transaction.update(adRef, {'interestedUsers': interestedUsers});
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to toggle interest: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserFavorites(
    String userId,
  ) async {
    try {
      final adsSnapshot =
          await _firestore
              .collection('car_ads')
              .where('favoritedByUsers', arrayContains: userId)
              .where('isActive', isEqualTo: true)
              .get();

      final ads =
          adsSnapshot.docs
              .map((doc) => AdsModel.fromMap(doc.data(), doc.id))
              .toList();

      final result = <AdWithUserModel>[];

      for (final ad in ads) {
        try {
          final userDoc =
              await _firestore.collection('Users').doc(ad.userId).get();
          UserModel? userModel;
          if (userDoc.exists) {
            userModel = UserModel.fromMap(userDoc.data()!);
          }
          result.add(
            AdWithUserModel(ad: ad, userData: userModel, isFavorite: true),
          );
        } catch (e) {
          result.add(AdWithUserModel(ad: ad, isFavorite: true));
        }
      }

      return Right(result);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserActiveAds(
    String userId,
  ) async {
    try {
      final adsSnapshot =
          await _firestore
              .collection('car_ads')
              .where('userId', isEqualTo: userId)
              .where('isActive', isEqualTo: true)
              .get();

      final ads =
          adsSnapshot.docs
              .map((doc) => AdsModel.fromMap(doc.data(), doc.id))
              .toList();

      final result = <AdWithUserModel>[];

      for (final ad in ads) {
        try {
          final userDoc =
              await _firestore.collection('Users').doc(ad.userId).get();
          UserModel? userModel;
          if (userDoc.exists) {
            userModel = UserModel.fromMap(userDoc.data()!);
          }
          result.add(AdWithUserModel(ad: ad, userData: userModel));
        } catch (e) {
          result.add(AdWithUserModel(ad: ad));
        }
      }

      return Right(result);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deactivateAd(String adId) async {
    try {
      await _firestore.collection('car_ads').doc(adId).update({
        'isActive': false,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to deactivate ad: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateAd(AdsModel ad) async {
    try {
      await _firestore.collection("car_ads").doc(ad.id).update(ad.toMap());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> createChat({
    required String adId,
    required String sellerId,
    required String buyerId,
  }) async {
    try {
      final existingChat =
          await _firestore
              .collection('chats')
              .where('adId', isEqualTo: adId)
              .where('participants', arrayContainsAny: [sellerId, buyerId])
              .get();

      if (existingChat.docs.isNotEmpty) {
        return Right(existingChat.docs.first.id);
      }

      final chatRef = await _firestore.collection('chats').add({
        'adId': adId,
        'sellerId': sellerId,
        'buyerId': buyerId,
        'participants': [sellerId, buyerId],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Right(chatRef.id);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Stream<List<ChatModel>> getChatsForUser(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = <ChatModel>[];

          for (final doc in snapshot.docs) {
            try {
              final chat = ChatModel.fromMap(doc.data(), doc.id);

              final lastMessage = await _firestore
                  .collection('chats')
                  .doc(doc.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .get()
                  .then(
                    (snap) =>
                        snap.docs.isNotEmpty
                            ? MessageModel.fromMap(
                              snap.docs.first.data(),
                              snap.docs.first.id,
                            )
                            : null,
                  );

              final unreadCount = await _firestore
                  .collection('chats')
                  .doc(doc.id)
                  .collection('messages')
                  .where('status', whereIn: ['sent', 'delivered'])
                  .where('senderId', isNotEqualTo: userId)
                  .where('isDeleted', isEqualTo: false)
                  .get()
                  .then((snap) => snap.size);

              final otherUserId =
                  chat.sellerId == userId ? chat.buyerId : chat.sellerId;
              final userDoc =
                  await _firestore.collection('Users').doc(otherUserId).get();
              final user =
                  userDoc.exists ? UserModel.fromMap(userDoc.data()!) : null;

              final adDoc =
                  await _firestore.collection('car_ads').doc(chat.adId).get();
              final ad =
                  adDoc.exists
                      ? AdsModel.fromMap(adDoc.data()!, adDoc.id)
                      : null;

              chats.add(
                chat.copyWith(
                  lastMessage: lastMessage,
                  unreadCount: unreadCount,
                  seller: chat.sellerId == userId ? null : user,
                  buyer: chat.buyerId == userId ? null : user,
                  ad: ad,
                ),
              );
            } catch (e) {
              continue;
            }
          }

          return chats;
        });
  }

  @override
  Stream<List<MessageModel>> getMessagesForChat(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return MessageModel.fromMap(data, doc.id);
              }).toList(),
        );
  }

  @override
  Future<Either<String, void>> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      final messages =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('status', whereIn: ['sent', 'delivered'])
              .where('senderId', isNotEqualTo: userId)
              .where('isDeleted', isEqualTo: false)
              .get();

      final batch = _firestore.batch();
      for (final doc in messages.docs) {
        batch.update(doc.reference, {'status': 'read'});
      }

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? replyToMessageId,
    String? replyToContent,
  }) async {
    try {
      if (content.trim().isEmpty) {
        return Left('Message content cannot be empty');
      }

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'chatId': chatId,
            'senderId': senderId,
            'content': content,
            'timestamp': FieldValue.serverTimestamp(),
            'status': 'sent',
            'replyToMessageId': replyToMessageId,
            'replyToContent': replyToContent,
            'isDeleted': false,
          });

      await _firestore.collection('chats').doc(chatId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      await messageRef.update({
        'isDeleted': true,
        'content': 'This message was deleted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('chats').doc(chatId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      return Left('Failed to delete message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getUserInterests(
    String userId,
  ) async {
    try {
      final adsSnapshot =
          await _firestore
              .collection('car_ads')
              .where('interestedUsers', arrayContains: userId)
              .where('isActive', isEqualTo: true)
              .get();

      final ads =
          adsSnapshot.docs
              .map((doc) => AdsModel.fromMap(doc.data(), doc.id))
              .toList();

      final result = <AdWithUserModel>[];

      for (final ad in ads) {
        try {
          final userDoc =
              await _firestore.collection('Users').doc(ad.userId).get();
          UserModel? userModel;
          if (userDoc.exists) {
            userModel = UserModel.fromMap(userDoc.data()!);
          }
          result.add(
            AdWithUserModel(ad: ad, userData: userModel, isInterested: true),
          );
        } catch (e) {
          result.add(AdWithUserModel(ad: ad, isInterested: true));
        }
      }

      return Right(result);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to get interested ads: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<UserModel>>> getInterestedUsers(
    String adId,
  ) async {
    try {
      final adDoc = await _firestore.collection('car_ads').doc(adId).get();

      if (!adDoc.exists) {
        return Left('Ad not found');
      }

      final interestedUserIds = List<String>.from(
        adDoc['interestedUsers'] ?? [],
      );

      if (interestedUserIds.isEmpty) {
        return Right([]);
      }

      final usersSnapshot =
          await _firestore
              .collection('Users')
              .where(FieldPath.documentId, whereIn: interestedUserIds)
              .get();

      final users =
          usersSnapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList();

      return Right(users);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Failed to get interested users: ${e.toString()}');
    }
  }
  
  @override
  Future<Either<String, String>> createPaymentRecord(PaymentModel payment) async {
    try {
      final docRef = await _firestore.collection('payments').add(payment.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
  
 @override
  Future<Either<String, UserPostLimit>> getUserPostLimit(String userId) async {
    try {
      final doc = await _firestore.collection('user_post_limits').doc(userId).get();
      
      if (!doc.exists) {
        // Create a new limit record if it doesn't exist
        final resetDate = DateTime.now().add(const Duration(days: 30));
        final newLimit = UserPostLimit(
          userId: userId,
          postCount: 0,
          resetDate: resetDate,
        );
        
        await _firestore.collection('user_post_limits').doc(userId).set(newLimit.toMap());
        return Right(newLimit);
      }
      
      final limit = UserPostLimit.fromMap(doc.data()!);
      
      // Check if reset date has passed
      if (DateTime.now().isAfter(limit.resetDate)) {
        final newResetDate = DateTime.now().add(const Duration(days: 30));
        await _firestore.collection('user_post_limits').doc(userId).update({
          'postCount': 0,
          'resetDate': newResetDate.toIso8601String(),
        });
        return Right(limit.copyWith(postCount: 0, resetDate: newResetDate));
      }
      
      return Right(limit);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
  
  
@override
  Future<Either<String, void>> incrementPostCount(String userId) async {
    try {
      await _firestore.collection('user_post_limits').doc(userId).update({
        'postCount': FieldValue.increment(1),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
  
@override
  Future<Either<String, void>> updatePaymentStatus({
    required String paymentId,
    required String status,
    required String transactionId,
  }) async {
    try {
      await _firestore.collection('payments').doc(paymentId).update({
        'paymentStatus': status,
        'transactionId': transactionId,
        'paymentDate': FieldValue.serverTimestamp(),
      });
      
      if (status == 'Success') {
        final paymentDoc = await _firestore.collection('payments').doc(paymentId).get();
        final userId = paymentDoc['userId'] as String;
        await _firestore.collection('user_post_limits').doc(userId).update({
          'isPremium': true,
          'premiumExpiryDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        });
      }
      
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
