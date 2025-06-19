part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {
  final String? messageId;

  const ChatLoading({this.messageId});

  @override
  List<Object> get props => [messageId ?? ''];
}

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

final class MessagesLoading extends ChatState {
  final bool isInitialLoad;

  const MessagesLoading({this.isInitialLoad = false});

  @override
  List<Object> get props => [isInitialLoad];
}

final class ChatScreenState extends ChatState {
  final Stream<List<MessageModel>> messages;
  final MessageModel? replyingToMessage;
  final String? highlightedMessageId;

  const ChatScreenState({
    required this.messages,
    this.replyingToMessage,
    this.highlightedMessageId,
  });

  ChatScreenState copyWith({
    Stream<List<MessageModel>>? messages,
    MessageModel? replyingToMessage,
    String? highlightedMessageId,
  }) {
    return ChatScreenState(
      messages: messages ?? this.messages,
      replyingToMessage: replyingToMessage,
      highlightedMessageId: highlightedMessageId,
    );
  }

  @override
  List<Object> get props => [messages, replyingToMessage ?? '', highlightedMessageId ?? ''];
}

final class MessageSent extends ChatState {}

final class MessagesMarkedRead extends ChatState {}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}