import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';

class ScreenAdChatList extends StatefulWidget {
  const ScreenAdChatList({super.key});

  @override
  State<ScreenAdChatList> createState() => _ScreenAdChatListState();
}

class _ScreenAdChatListState extends State<ScreenAdChatList> {
  final _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    context.read<ChatBloc>().add(LoadChatsEvent(_currentUserId));
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.zPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChats,
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return _buildShimmerLoader(context);
          }

          if (state is ChatsLoaded) {
            return StreamBuilder<List<ChatModel>>(
              stream: state.chats,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _buildShimmerLoader(context);
                }

                final chats = snapshot.data!;
                if (chats.isEmpty) {
                  return const Center(
                    child: Text('No chats yet'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUser = chat.sellerId == _currentUserId
                        ? chat.buyer
                        : chat.seller;
                    final ad = chat.ad;
                    final lastMessage = chat.lastMessage;
                    final initials = otherUser?.fullName?.isNotEmpty ?? false
                        ? otherUser!.fullName![0].toUpperCase()
                        : '?';

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      onTap: () async {
                        context.read<ChatBloc>().add(
                              MarkMessagesReadEvent(
                                chatId: chat.id,
                                userId: _currentUserId,
                              ),
                            );

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
                        _loadChats();
                      },
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            AppColors.zPrimaryColor.withOpacity(0.15),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zPrimaryColor,
                          ),
                        ),
                      ),
                      title: Row(
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
                          if (lastMessage != null)
                            Text(
                              _formatTime(lastMessage.timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ad != null)
                            Text(
                              '${ad.brand} ${ad.model}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.zWhite,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lastMessage?.content ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.zGrey,
                                    fontWeight: chat.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (chat.unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
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
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong!'));
        },
      ),
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: 11,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Shimmer.fromColors(
            baseColor: AppColors.zSecondBackground ,
            highlightColor: AppColors.zBackGround,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 16, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 14, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 100, height: 12, color: Colors.white),
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
