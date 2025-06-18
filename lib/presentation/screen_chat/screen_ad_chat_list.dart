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
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatsLoading) {
              return _buildShimmerLoader(context);
            }
        
            if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadChats,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
        
            if (state is ChatsLoaded) {
              return StreamBuilder<List<ChatModel>>(
                stream: state.chats,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
        
                  if (!snapshot.hasData) {
                    return _buildShimmerLoader(context);
                  }
        
                  final chats = snapshot.data!;
        
                  if (chats.isEmpty) {
                    return const Center(
                      child: Text(
                        'No chats yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
        
                  return RefreshIndicator(
                    onRefresh: () async => _loadChats(),
                    child: ListView.separated(
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final otherUser = chat.sellerId == _currentUserId 
                            ? chat.buyer 
                            : chat.seller;
                        final ad = chat.ad;
                        final lastMessage = chat.lastMessage;
                        final initials = otherUser?.fullName?.isNotEmpty ?? false
                            ? otherUser!.fullName!.substring(0, 1).toUpperCase()
                            : '?';

                        return ListTile(
                          leading: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.zPrimaryColor.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.zPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  otherUser?.fullName ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (chat.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.zPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    chat.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ad != null)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${ad.brand} ${ad.model}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[100],
                                        ),
                                      ),
                                    ),
                                    if (lastMessage != null)
                                      Text(
                                        _formatTime(lastMessage.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                  ],
                                ),
                              if (lastMessage != null)
                                Text(
                                  lastMessage.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
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
                        );
                      },
                    ),
                  );
                },
              );
            }
            return _buildShimmerLoader(context);
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDarkMode ? AppColors.zSecondBackground : Colors.grey[300]!;
    final highlightColor = isDarkMode 
        ? AppColors.zSecondBackground.withOpacity(0.6)
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: 9,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            title: Container(
              width: 120,
              height: 16,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 4),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                Container(
                  width: 80,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}