part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateChatEvent extends ChatEvent {
  final String adId;
  final String sellerId;
  final String buyerId;

  const CreateChatEvent({
    required this.adId,
    required this.sellerId,
    required this.buyerId,
  });

  @override
  List<Object> get props => [adId, sellerId, buyerId];
}

class LoadChatsEvent extends ChatEvent {
  final String userId;

  const LoadChatsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;
  final bool isInitialLoad;

  const LoadMessagesEvent(this.chatId, {this.isInitialLoad = true});

  @override
  List<Object> get props => [chatId, isInitialLoad];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String? replyToMessageId;
  final String? replyToContent;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
    this.replyToMessageId,
    this.replyToContent,
  });

  @override
  List<Object> get props => [chatId, senderId, content, replyToMessageId ?? '', replyToContent ?? ''];
}

class DeleteMessageEvent extends ChatEvent {
  final String chatId;
  final String messageId;

  const DeleteMessageEvent({
    required this.chatId,
    required this.messageId,
  });

  @override
  List<Object> get props => [chatId, messageId];
}

class MarkMessagesReadEvent extends ChatEvent {
  final String chatId;
  final String userId;

  const MarkMessagesReadEvent({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId, userId];
}