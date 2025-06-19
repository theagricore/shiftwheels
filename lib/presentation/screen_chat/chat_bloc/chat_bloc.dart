import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/create_chat_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/delete_message_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_chats_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_messages_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/mark_messages_read_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatUseCase _createChatUseCase;
  final GetChatsUseCase _getChatsUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final MarkMessagesReadUseCase _markMessagesReadUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;

  ChatBloc({
    required CreateChatUseCase createChatUseCase,
    required GetChatsUseCase getChatsUseCase,
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required MarkMessagesReadUseCase markMessagesReadUseCase,
    required DeleteMessageUseCase deleteMessageUseCase,
  }) : _createChatUseCase = createChatUseCase,
       _getChatsUseCase = getChatsUseCase,
       _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _markMessagesReadUseCase = markMessagesReadUseCase,
       _deleteMessageUseCase = deleteMessageUseCase,
       super(ChatInitial()) {
    on<CreateChatEvent>(_onCreateChat);
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesReadEvent>(_onMarkMessagesRead);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<SetReplyMessageEvent>(_onSetReplyMessage);
    on<ClearReplyMessageEvent>(_onClearReplyMessage);
    on<HighlightMessageEvent>(_onHighlightMessage);
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await _createChatUseCase(
      param: CreateChatParams(
        adId: event.adId,
        sellerId: event.sellerId,
        buyerId: event.buyerId,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(failure)),
      (chatId) => emit(ChatCreated(chatId)),
    );
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatsLoading());
    try {
      final stream = _getChatsUseCase(param: event.userId);
      emit(ChatsLoaded(stream));
    } catch (e) {
      emit(ChatError('Failed to load chats: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessagesLoading());
    try {
      final stream = _getMessagesUseCase(param: event.chatId);
      emit(ChatScreenState(messages: stream));
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _sendMessageUseCase(
      param: SendMessageParams(
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
        replyToMessageId: event.replyToMessageId,
        replyToContent: event.replyToContent,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(failure)),
      (_) {
        if (state is ChatScreenState) {
          emit((state as ChatScreenState).copyWith(
            messages: _getMessagesUseCase(param: event.chatId),
            replyingToMessage: null,
            highlightedMessageId: null,
          ));
        }
      },
    );
  }

  Future<void> _onMarkMessagesRead(
    MarkMessagesReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _markMessagesReadUseCase(
      param: MarkMessagesReadParams(chatId: event.chatId, userId: event.userId),
    );

    result.fold(
      (failure) => emit(ChatError(failure)),
      (_) => null, // Stream will handle updates
    );
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _deleteMessageUseCase(
      param: DeleteMessageParams(
        chatId: event.chatId,
        messageId: event.messageId,
      ),
    );

    result.fold(
      (failure) => emit(ChatError(failure)),
      (_) => null, // Stream will handle updates
    );
  }

  void _onSetReplyMessage(
    SetReplyMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatScreenState) {
      emit((state as ChatScreenState).copyWith(replyingToMessage: event.message));
    } else {
      emit(ChatScreenState(
        messages: _getMessagesUseCase(param: event.chatId),
        replyingToMessage: event.message,
      ));
    }
  }

  void _onClearReplyMessage(
    ClearReplyMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatScreenState) {
      emit((state as ChatScreenState).copyWith(replyingToMessage: null));
    }
  }

  void _onHighlightMessage(
    HighlightMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatScreenState) {
      emit((state as ChatScreenState).copyWith(highlightedMessageId: event.messageId));
      Future.delayed(const Duration(seconds: 2), () {
        if (state is ChatScreenState) {
          emit((state as ChatScreenState).copyWith(highlightedMessageId: null));
        }
      });
    }
  }
}