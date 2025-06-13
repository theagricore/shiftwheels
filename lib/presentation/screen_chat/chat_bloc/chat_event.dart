part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateChatEvent extends ChatEvent {
  final String adId;
  final String sellerId;

  const CreateChatEvent({required this.adId, required this.sellerId});

  @override
  List<Object> get props => [adId, sellerId];
}

class LoadUserChatsStreamEvent extends ChatEvent {
  const LoadUserChatsStreamEvent();
}

class LoadChatMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadChatMessagesEvent({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;

  const SendMessageEvent({required this.chatId, required this.content});

  @override
  List<Object> get props => [chatId, content];
}

class MarkMessagesReadEvent extends ChatEvent {
  final String chatId;

  const MarkMessagesReadEvent({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class UpdateChatListEvent extends ChatEvent {
  final List<ChatModel> chats;

  const UpdateChatListEvent(this.chats);

  @override
  List<Object> get props => [chats];
}