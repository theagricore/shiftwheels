import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';

class ReplyAndDeleteWidget extends StatelessWidget {
  const ReplyAndDeleteWidget({
    super.key,
    required this.chatId,
    required this.message,
    required this.isMe,
  });

  final String chatId;
  final MessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        final double iconSize = isWeb ? 20 : 24;
        final double textSize = isWeb ? 14 : 16;
        final EdgeInsets padding = isWeb
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 10);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: padding,
                  leading: Icon(Icons.reply, size: iconSize),
                  title: Text(
                    'Reply',
                    style: TextStyle(fontSize: textSize),
                  ),
                  onTap: () {
                    context.read<ChatBloc>().add(
                          SetReplyMessageEvent(
                            message: message,
                            chatId: chatId,
                          ),
                        );
                    Navigator.pop(context);
                  },
                ),
                if (isMe && !message.isDeleted)
                  ListTile(
                    contentPadding: padding,
                    leading: Icon(Icons.delete, color: Colors.red, size: iconSize),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      context.read<ChatBloc>().add(
                            DeleteMessageEvent(
                              chatId: chatId,
                              messageId: message.id,
                            ),
                          );
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
