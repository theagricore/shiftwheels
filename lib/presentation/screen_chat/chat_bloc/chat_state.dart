part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatCreated extends ChatState {
  final String chatId;

  const ChatCreated(this.chatId);

  @override
  List<Object> get props => [chatId];
}

final class ChatsLoading extends ChatState {}

final class ChatsLoaded extends ChatState {
  final Stream<List<ChatModel>> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

final class MessagesLoading extends ChatState {}

final class MessagesLoaded extends ChatState {
  final Stream<List<MessageModel>> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

final class MessageSent extends ChatState {}

final class MessagesMarkedRead extends ChatState {}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}