import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/create_chat_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_chat_messages_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/get_user_chats_stream_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/mark_messages_read_usecase.dart';
import 'package:shiftwheels/domain/add_post/usecase/chat_usecase/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatUsecase _createChatUsecase;
  final GetUserChatsStreamUsecase _getUserChatsStreamUsecase;
  final GetChatMessagesUsecase _getChatMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final MarkMessagesReadUsecase _markMessagesReadUsecase;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatBloc({
    required CreateChatUsecase createChatUsecase,
    required GetUserChatsStreamUsecase getUserChatsStreamUsecase,
    required GetChatMessagesUsecase getChatMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required MarkMessagesReadUsecase markMessagesReadUsecase,
  }) : _createChatUsecase = createChatUsecase,
       _getUserChatsStreamUsecase = getUserChatsStreamUsecase,
       _getChatMessagesUsecase = getChatMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       _markMessagesReadUsecase = markMessagesReadUsecase,
       super(ChatInitial()) {
    on<CreateChatEvent>(_onCreateChat);
    on<LoadUserChatsStreamEvent>(_onLoadUserChatsStream);
    on<LoadChatMessagesEvent>(_onLoadChatMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesReadEvent>(_onMarkMessagesRead);
    on<UpdateChatListEvent>(_onUpdateChatList);
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      emit(ChatError('User not logged in'));
      return;
    }

    final result = await _createChatUsecase.call(
      param: CreateChatParams(
        adId: event.adId,
        buyerId: currentUserId,
        sellerId: event.sellerId,
      ),
    );

    result.fold(
      (error) => emit(ChatError(error)),
      (chatId) => emit(ChatCreated(chatId)),
    );
  }

Future<void> _onLoadUserChatsStream(
  LoadUserChatsStreamEvent event,
  Emitter<ChatState> emit,
) async {
  emit(ChatLoading());
  final currentUserId = _auth.currentUser?.uid;
  if (currentUserId == null) {
    emit(ChatError('User not logged in'));
    return;
  }

  final result = await _getUserChatsStreamUsecase.call(param: currentUserId);

  result.fold(
    (error) => emit(ChatError(error)),
    (stream) {
      // Emit loaded state with the stream
      emit(UserChatsStreamLoaded(stream));
    },
  );
}

Future<void> _onLoadChatMessages(LoadChatMessagesEvent event, Emitter<ChatState> emit) async {
  emit(ChatLoading());
  
  final result = await _getChatMessagesUsecase.call(param: event.chatId);

  result.fold(
    (error) => emit(ChatError(error)),
    (stream) {
      emit(ChatMessagesLoaded(stream));
    },
  );
}

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      emit(ChatError('User not logged in'));
      return;
    }

    final result = await _sendMessageUsecase.call(
      param: SendMessageParams(
        chatId: event.chatId,
        senderId: currentUserId,
        content: event.content,
      ),
    );

    result.fold((error) => emit(ChatError(error)), (_) => emit(MessageSent()));
  }

  Future<void> _onMarkMessagesRead(
    MarkMessagesReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      emit(ChatError('User not logged in'));
      return;
    }

    final result = await _markMessagesReadUsecase.call(
      param: MarkMessagesReadParams(
        chatId: event.chatId,
        userId: currentUserId,
      ),
    );

    result.fold(
      (error) => emit(ChatError(error)),
      (_) => emit(MessagesMarkedRead()),
    );
  }

  void _onUpdateChatList(UpdateChatListEvent event, Emitter<ChatState> emit) {
    emit(ChatListUpdated(event.chats));
  }
}
