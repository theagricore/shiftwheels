import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScreenAdChat extends StatelessWidget {
  final String chatId;
  final AdsModel ad;
  final UserModel? userData;

  const ScreenAdChat({
    super.key,
    required this.chatId,
    required this.ad,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(LoadChatMessagesEvent(chatId: chatId)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${ad.brand} ${ad.model} (${ad.year})",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                userData?.fullName ?? 'Unknown User',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: AppColors.zPrimaryColor,
        ),
        body: Column(
          children: [
            Expanded(child: _MessagesList(chatId: chatId)),
            _MessageInput(chatId: chatId),
          ],
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final String chatId;

  const _MessagesList({required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatMessagesLoaded) {
          return StreamBuilder<List<MessageModel>>(
            stream: state.messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No messages yet'));
              }
              final messages = snapshot.data!;
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser =
                      message.senderId == FirebaseAuth.instance.currentUser?.uid;
                  return _MessageBubble(
                    message: message,
                    isCurrentUser: isCurrentUser,
                  );
                },
              );
            },
          );
        } else if (state is ChatError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Start the conversation'));
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;

  const _MessageBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment:
            isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? AppColors.zPrimaryColor
                : AppColors.zWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentUser ? AppColors.zPrimaryColor : AppColors.zblack,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : AppColors.zblack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeago.format(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isCurrentUser ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final String chatId;
  final TextEditingController _controller = TextEditingController();

  _MessageInput({required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: AppColors.zWhite,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.zPrimaryColor),
            onPressed: () {
              final content = _controller.text.trim();
              if (content.isNotEmpty) {
                context.read<ChatBloc>().add(SendMessageEvent(
                      chatId: chatId,
                      content: content,
                    ));
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}