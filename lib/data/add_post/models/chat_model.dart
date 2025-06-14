import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

class ChatModel {
  final String id;
  final String adId;
  final String sellerId;
  final String buyerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? seller;
  final UserModel? buyer;
  final AdsModel? ad;
  final MessageModel? lastMessage;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.adId,
    required this.sellerId,
    required this.buyerId,
    required this.createdAt,
    required this.updatedAt,
    this.seller,
    this.buyer,
    this.ad,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      adId: map['adId'] as String,
      sellerId: map['sellerId'] as String,
      buyerId: map['buyerId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ChatModel copyWith({
    String? id,
    String? adId,
    String? sellerId,
    String? buyerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? seller,
    UserModel? buyer,
    AdsModel? ad,
    MessageModel? lastMessage,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      adId: adId ?? this.adId,
      sellerId: sellerId ?? this.sellerId,
      buyerId: buyerId ?? this.buyerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      ad: ad ?? this.ad,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}