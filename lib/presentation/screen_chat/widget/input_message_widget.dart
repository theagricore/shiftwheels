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
  void initState() {
    super.initState();
    print('InputMessageWidget initState: replyingToMessage = ${widget.replyingToMessage?.id}');
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Column(
      children: [
        if (widget.replyingToMessage != null)
          _buildReplyBanner(context, widget.replyingToMessage!, isDarkMode, isWeb),
        Padding(
          padding: EdgeInsets.all(isWeb ? 12.0 : 8.0),
          child: Row(
            children: [
              Expanded(child: _buildInputField(isDarkMode, isWeb)),
              SizedBox(width: isWeb ? 12 : 8),
              _buildSendButton(isWeb),
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
    bool isWeb,
  ) {
    final replyingTo = replyMessage.senderId == currentUserId
        ? "yourself"
        : widget.otherUser?.fullName ?? "Unknown";

    print('Building reply banner for message: ${replyMessage.id}');

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.zDarkGrey.withOpacity(0.3)
            : AppColors.zPrimaryColor.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: AppColors.zPrimaryColor, width: 1.5),
          left: BorderSide(color: AppColors.zPrimaryColor, width: 10),
          right: BorderSide(color: AppColors.zPrimaryColor, width: 1),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 16 : 12,
        vertical: isWeb ? 12 : 10,
      ),
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
                    fontSize: isWeb ? 12 : 13,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  replyMessage.displayContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isWeb ? 12 : null,
                    color: isDarkMode ? AppColors.zGrey : AppColors.zGrey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: isWeb ? 20 : 24,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            onPressed: () {
              print('Clear reply tapped');
              context.read<ChatBloc>().add(ClearReplyMessageEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(bool isDarkMode, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 16 : 13,
        vertical: isWeb ? 4 : 0,
      ),
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
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: isWeb ? 14 : null,
          ),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(
              color: isDarkMode ? AppColors.zGrey : AppColors.zGrey,
              fontSize: isWeb ? 14 : null,
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

  Widget _buildSendButton(bool isWeb) {
    return CircleAvatar(
      radius: isWeb ? 24 : 26,
      backgroundColor: AppColors.zPrimaryColor,
      child: IconButton(
        icon: Icon(
          Icons.send,
          color: Colors.white,
          size: isWeb ? 20 : 24,
        ),
        onPressed: _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    print('Sending message with replyTo: ${widget.replyingToMessage?.id}');

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
    context.read<ChatBloc>().add(ClearReplyMessageEvent());
  }
}