import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/input_message_widget.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/message_bubble.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/message_screen_app_bar.dart';

class ScreenAdChat extends StatelessWidget {
  final String chatId;
  final UserModel? otherUser;
  final AdsModel? ad;

  const ScreenAdChat({
    super.key,
    required this.chatId,
    required this.otherUser,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final messageController = TextEditingController();
    final scrollController = ScrollController();
    final messageKeys = <String, GlobalKey>{};

    context.read<ChatBloc>().add(LoadMessagesEvent(chatId));
    context.read<ChatBloc>().add(
      MarkMessagesReadEvent(chatId: chatId, userId: currentUserId),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;

        return Scaffold(
          appBar: MessageScreenAppBar(otherUser: otherUser, ad: ad),
          body: Center(
            child: ConstrainedBox(
              constraints: isWeb
                  ? const BoxConstraints(maxWidth: 900)
                  : const BoxConstraints(),
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatScreenState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(
                          scrollController.position.maxScrollExtent,
                        );
                      }
                    });
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildMessageList(
                          context,
                          state,
                          scrollController,
                          messageKeys,
                          currentUserId,
                        ),
                      ),
                      _buildMessageInput(
                        context,
                        state,
                        messageController,
                        currentUserId,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    ChatState state,
    ScrollController scrollController,
    Map<String, GlobalKey> messageKeys,
    String currentUserId,
  ) {
    if (state is MessagesLoading && state.isInitialLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChatScreenState) {
      return StreamBuilder<List<MessageModel>>(
        stream: state.messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!;
          final chatItems = _buildChatItems(messages);

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: chatItems.length,
            itemBuilder: (context, index) {
              final item = chatItems[index];
              if (item is String) {
                return _buildDateTag(item);
              } else if (item is MessageModel) {
                final isMe = item.senderId == currentUserId;
                final key = messageKeys[item.id] ??= GlobalKey();
                return Container(
                  key: key,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildMessageWidget(context, item, isMe, state),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDateTag(String dateText) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          dateText,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }

  List<dynamic> _buildChatItems(List<MessageModel> messages) {
    final chatItems = <dynamic>[];
    String? lastDate;
    for (final message in messages) {
      final msgDate = DateFormat('yyyy-MM-dd').format(message.timestamp);
      if (lastDate != msgDate) {
        chatItems.add(getDateTag(message.timestamp));
        lastDate = msgDate;
      }
      chatItems.add(message);
    }
    return chatItems;
  }

  Widget _buildMessageWidget(
    BuildContext context,
    MessageModel message,
    bool isMe,
    ChatScreenState state,
  ) {
    return MessageBubble(
      message: message,
      isMe: isMe,
      chatId: chatId,
      highlightedMessageId: state.highlightedMessageId,
    );
  }

  Widget _buildMessageInput(
    BuildContext context,
    ChatState state,
    TextEditingController messageController,
    String currentUserId,
  ) {
    MessageModel? replyingToMessage;
    if (state is ChatScreenState) {
      replyingToMessage = state.replyingToMessage;
    }

    return InputMessageWidget(
      replyingToMessage: replyingToMessage,
      otherUser: otherUser,
      chatId: chatId,
    );
  }

  String getDateTag(DateTime messageDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(
      messageDate.year,
      messageDate.month,
      messageDate.day,
    );

    if (msgDate == today) {
      return 'Today';
    } else if (msgDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${messageDate.day.toString().padLeft(2, '0')} '
          '${_getMonthName(messageDate.month)} '
          '${messageDate.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
