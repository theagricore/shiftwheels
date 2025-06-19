import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';

class ChatCardWidget extends StatelessWidget {
  final List<ChatModel> chats;
  final String currentUserId;
  final VoidCallback onRefresh;

  const ChatCardWidget({
    super.key,
    required this.chats,
    required this.currentUserId,
    required this.onRefresh,
  });

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final otherUser =
            chat.sellerId == currentUserId ? chat.buyer : chat.seller;
        final ad = chat.ad;
        final lastMessage = chat.lastMessage;
        final initials =
            otherUser?.fullName?.isNotEmpty ?? false
                ? otherUser!.fullName![0].toUpperCase()
                : '?';

        return InkWell(
          onTap: () async {
            context.read<ChatBloc>().add(
              MarkMessagesReadEvent(chatId: chat.id, userId: currentUserId),
            );
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: context.read<ChatBloc>(),
                      child: ScreenAdChat(
                        chatId: chat.id,
                        otherUser: otherUser,
                        ad: ad,
                      ),
                    ),
              ),
            );
            onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.zGrey.withOpacity(0.15),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.zPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              otherUser?.fullName ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (lastMessage != null)
                                Text(
                                  _formatTime(lastMessage.timestamp),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (chat.unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.zPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    chat.unreadCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (ad != null)
                            Text(
                              '${ad.brand} ${ad.model}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage?.content ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.zGrey,
                                fontWeight:
                                    chat.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
