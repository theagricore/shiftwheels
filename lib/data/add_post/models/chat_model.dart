import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String adId;
  final String buyerId;
  final String sellerId;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;

  ChatModel({
    required this.id,
    required this.adId,
    required this.buyerId,
    required this.sellerId,
    required this.lastMessage,
    required this.lastMessageTime,
    this.hasUnreadMessages = false,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      adId: map['adId'] as String,
      buyerId: map['buyerId'] as String,
      sellerId: map['sellerId'] as String,
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      hasUnreadMessages: map['hasUnreadMessages'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'hasUnreadMessages': hasUnreadMessages,
    };
  }
}
