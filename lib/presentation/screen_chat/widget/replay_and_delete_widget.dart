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
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              context.read<ChatBloc>().add(
                SetReplyMessageEvent(message: message, chatId: chatId),
              );
              Navigator.pop(context);
            },
          ),
          if (isMe && !message.isDeleted)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
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
    );
  }
}
