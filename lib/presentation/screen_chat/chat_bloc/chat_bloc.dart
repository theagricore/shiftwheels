import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/create_chat_usecase.dart';
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

  ChatBloc({
    required CreateChatUseCase createChatUseCase,
    required GetChatsUseCase getChatsUseCase,
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required MarkMessagesReadUseCase markMessagesReadUseCase,
  })  : _createChatUseCase = createChatUseCase,
        _getChatsUseCase = getChatsUseCase,
        _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _markMessagesReadUseCase = markMessagesReadUseCase,
        super(ChatInitial()) {
    on<CreateChatEvent>(_onCreateChat);
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesReadEvent>(_onMarkMessagesRead);
  }

  Future<void> _onCreateChat(CreateChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await _createChatUseCase(param: CreateChatParams(
      adId: event.adId,
      sellerId: event.sellerId,
      buyerId: event.buyerId,
    ));

    result.fold(
      (failure) => emit(ChatError(failure)),
      (chatId) => emit(ChatCreated(chatId)),
    );
  }

  Future<void> _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    try {
      final stream = _getChatsUseCase(param: event.userId);
      emit(ChatsLoaded(stream));
    } catch (e) {
      emit(ChatError('Failed to load chats: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(MessagesLoading());
    try {
      final stream = _getMessagesUseCase(param: event.chatId);
      emit(MessagesLoaded(stream));
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await _sendMessageUseCase(param: SendMessageParams(
      chatId: event.chatId,
      senderId: event.senderId,
      content: event.content,
    ));

    result.fold(
      (failure) => emit(ChatError(failure)),
      (_) => null,
    );
  }

  Future<void> _onMarkMessagesRead(MarkMessagesReadEvent event, Emitter<ChatState> emit) async {
    final result = await _markMessagesReadUseCase(param: MarkMessagesReadParams(
      chatId: event.chatId,
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(ChatError(failure)),
      (_) => null,
    );
  }
}