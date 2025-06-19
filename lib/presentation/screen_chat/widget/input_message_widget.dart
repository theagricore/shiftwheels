import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';

class InputMessageWidget extends StatefulWidget {
  const InputMessageWidget({
    super.key,
    required this.replyingToMessage,
    required this.otherUser,
    required this.chatId,
  });

  final MessageModel? replyingToMessage;
  final UserModel? otherUser;
  final String chatId;

  @override
  State<InputMessageWidget> createState() => _InputMessageWidgetState();
}

class _InputMessageWidgetState extends State<InputMessageWidget> {
  final TextEditingController messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.replyingToMessage != null)
          _buildReplyBanner(context, widget.replyingToMessage!),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: _buildInputField()),
              const SizedBox(width: 8),
              _buildSendButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyBanner(BuildContext context, MessageModel replyMessage) {
    final replyingTo =
        replyMessage.senderId == currentUserId
            ? "yourself"
            : widget.otherUser?.fullName ?? "Unknown";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.zPrimaryColor.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: AppColors.zPrimaryColor, width: 1.5),
          left: BorderSide(color: AppColors.zPrimaryColor, width: 10),
          right: BorderSide(color: AppColors.zPrimaryColor, width: 1),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to $replyingTo',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  replyMessage.displayContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.zGrey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed:
                () => context.read<ChatBloc>().add(ClearReplyMessageEvent()),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppColors.zBackGround,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.zPrimaryColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            hintText: 'Type your message...',
            border: InputBorder.none,
            fillColor: AppColors.zBackGround,
          ),
          maxLines: null,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.zPrimaryColor,
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessageEvent(
        chatId: widget.chatId,
        senderId: currentUserId,
        content: text,
        replyToMessageId: widget.replyingToMessage?.id,
        replyToContent: widget.replyingToMessage?.displayContent,
      ),
    );

    messageController.clear();
  }
}
