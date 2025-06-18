import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';

enum MessageStatus { sent, delivered, read }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;
  final UserModel? sender;
  final String? replyToMessageId;
  final String? replyToContent;
  final bool isDeleted;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.sender,
    this.replyToMessageId,
    this.replyToContent,
    this.isDeleted = false,
  });

  String get displayContent => isDeleted ? 'This message was deleted' : content;

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime timestamp;
    if (map['timestamp'] is Timestamp) {
      timestamp = (map['timestamp'] as Timestamp).toDate();
    } else if (map['timestamp'] is String) {
      timestamp = DateTime.parse(map['timestamp'] as String);
    } else {
      timestamp = DateTime.now();
    }

    MessageStatus status;
    if (map['status'] == null) {
      status = MessageStatus.sent;
    } else {
      status = MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => MessageStatus.sent,
      );
    }

    return MessageModel(
      id: id,
      chatId: map['chatId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      content: map['content'] as String? ?? '',
      timestamp: timestamp,
      status: status,
      replyToMessageId: map['replyToMessageId'] as String?,
      replyToContent: map['replyToContent'] as String?,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.toString().split('.').last,
      'replyToMessageId': replyToMessageId,
      'replyToContent': replyToContent,
      'isDeleted': isDeleted,
    };
  }
}