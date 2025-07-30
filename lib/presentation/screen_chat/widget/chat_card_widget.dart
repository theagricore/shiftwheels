import 'package:cached_network_image/cached_network_image.dart';
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final aWeekAgo = today.subtract(const Duration(days: 7));

    if (date.isAfter(today)) {
      return DateFormat('h:mm a').format(date).toLowerCase();
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else if (date.isAfter(aWeekAgo)) {
      return DateFormat('EEE').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isWeb = MediaQuery.of(context).size.width > 600;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(isWeb ? 8 : 12),
      itemCount: chats.length,
      separatorBuilder: (_, __) => SizedBox(height: isWeb ? 4 : 8),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final otherUser = chat.sellerId == currentUserId ? chat.buyer : chat.seller;
        final ad = chat.ad;
        final lastMessage = chat.lastMessage;
        final profileImageUrl = otherUser?.image;
        final bool hasUnreadMessages = chat.unreadCount > 0;

        return Card(
          elevation: isWeb ? 1 : 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isWeb ? 8 : 12),
            side: BorderSide(
              color: AppColors.zGrey.withOpacity(0.3),
              width: isWeb ? 0.5 : 0.8,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(isWeb ? 8 : 12),
            onTap: () async {
              context.read<ChatBloc>().add(
                MarkMessagesReadEvent(chatId: chat.id, userId: currentUserId),
              );
              
              if (isWeb) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ChatBloc>(),
                      child: ScreenAdChat(
                        chatId: chat.id,
                        otherUser: otherUser,
                        ad: ad,
                      ),
                    ),
                  ),
                );
              } else {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ChatBloc>(),
                      child: ScreenAdChat(
                        chatId: chat.id,
                        otherUser: otherUser,
                        ad: ad,
                      ),
                    ),
                  ),
                );
              }
              
              onRefresh();
            },
            child: Padding(
              padding: EdgeInsets.all(isWeb ? 8 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasUnreadMessages
                                ? theme.primaryColor
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: isWeb ? 24 : 28,
                          backgroundColor: isDarkMode
                              ? AppColors.zDarkGrey
                              : AppColors.zGrey.withOpacity(0.1),
                          backgroundImage: profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? CachedNetworkImageProvider(profileImageUrl)
                                  as ImageProvider<Object>?
                              : null,
                          child: profileImageUrl == null || profileImageUrl.isEmpty
                              ? Text(
                                  otherUser?.fullName?.isNotEmpty ?? false
                                      ? otherUser!.fullName![0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: isWeb ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      if (hasUnreadMessages)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode
                                    ? AppColors.zDarkGrey
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: isWeb ? 12 : 16),

                  // Chat content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                otherUser?.fullName ?? 'Unknown User',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: hasUnreadMessages
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: hasUnreadMessages
                                      ? theme.primaryColor
                                      : theme.textTheme.titleMedium?.color,
                                  fontSize: isWeb ? 15 : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (lastMessage != null)
                              Text(
                                _formatTime(lastMessage.timestamp),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: hasUnreadMessages
                                      ? theme.primaryColor
                                      : AppColors.zGrey,
                                  fontWeight: hasUnreadMessages
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: isWeb ? 11 : null, // Reduced from bodySmall to 11 for web
                                ),
                              ),
                          ],
                        ),

                        // Ad information
                        if (ad != null)
                          Text(
                            '${ad.brand} ${ad.model}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDarkMode
                                  ? AppColors.zGrey
                                  : AppColors.zGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: isWeb ? 13 : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                lastMessage?.content ?? 'No messages yet.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: hasUnreadMessages
                                      ? theme.textTheme.bodyMedium?.color
                                      : AppColors.zGrey,
                                  fontWeight: hasUnreadMessages
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: isWeb ? 13 : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (hasUnreadMessages)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                constraints: const BoxConstraints(
                                    minWidth: 24, minHeight: 24),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    if (!isDarkMode)
                                      BoxShadow(
                                        color: theme.primaryColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    chat.unreadCount.toString(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
          ),
        );
      },
    );
  }
}