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

final class UserChatsLoaded extends ChatState {
  final List<ChatModel> chats;

  const UserChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

final class ChatMessagesLoaded extends ChatState {
  final Stream<List<MessageModel>> messages;

  const ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [];
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}