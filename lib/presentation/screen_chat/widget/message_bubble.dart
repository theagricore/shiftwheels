import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/replay_and_delete_widget.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String chatId;
  final String? highlightedMessageId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.chatId,
    required this.highlightedMessageId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;

        return GestureDetector(
          onLongPress: () => _showOptions(context),
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb
                    ? constraints.maxWidth * 0.5
                    : MediaQuery.of(context).size.width * 0.8,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.id == highlightedMessageId
                      ? Colors.yellow.shade100
                      : null,
                  gradient: isMe
                      ? const LinearGradient(
                          colors: [AppColors.zOrange, AppColors.zPrimaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [AppColors.zGrey, Color(0xFFE2E2E2)],
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                    bottomRight:
                        isMe ? Radius.zero : const Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (message.replyToContent != null && !message.isDeleted)
                      GestureDetector(
                        onTap: () {
                          context.read<ChatBloc>().add(
                              HighlightMessageEvent(
                                  message.replyToMessageId ?? ''));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.replyToContent!,
                            style: TextStyle(
                              color:
                                  isMe ? Colors.white70 : Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontSize: isWeb ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      message.displayContent,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontStyle: message.isDeleted
                            ? FontStyle.italic
                            : FontStyle.normal,
                        fontSize: isWeb ? 13 : 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: isWeb ? 9 : 10,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (isMe && !message.isDeleted)
                          _buildMessageStatus(message.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  Widget _buildMessageStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
    }
  }

  void _showOptions(BuildContext context) {
    final isMe = FirebaseAuth.instance.currentUser?.uid == message.senderId;

    showModalBottomSheet(
      context: context,
      builder: (_) => ReplyAndDeleteWidget(
        chatId: chatId,
        message: message,
        isMe: isMe,
      ),
    );
  }
}
