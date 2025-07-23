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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        if (widget.replyingToMessage != null)
          _buildReplyBanner(context, widget.replyingToMessage!, isDarkMode),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: _buildInputField(isDarkMode)),
              const SizedBox(width: 8),
              _buildSendButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyBanner(
    BuildContext context,
    MessageModel replyMessage,
    bool isDarkMode,
  ) {
    final replyingTo =
        replyMessage.senderId == currentUserId
            ? "yourself"
            : widget.otherUser?.fullName ?? "Unknown";

    return Container(
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.zDarkGrey.withOpacity(0.3)
                : AppColors.zPrimaryColor.withOpacity(0.1),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  replyMessage.displayContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.zGrey : AppColors.zGrey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            onPressed:
                () => context.read<ChatBloc>().add(ClearReplyMessageEvent()),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.zDarkGrey : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDarkMode ? AppColors.zDarkGrey : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: messageController,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(
              color: isDarkMode ? AppColors.zGrey : AppColors.zGrey,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            fillColor: isDarkMode ? AppColors.zDarkGrey : Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
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
