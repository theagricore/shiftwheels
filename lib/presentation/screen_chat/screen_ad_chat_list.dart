import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class ScreenAdChatList extends StatefulWidget {
  const ScreenAdChatList({super.key});

  @override
  State<ScreenAdChatList> createState() => _ScreenAdChatListState();
}

class _ScreenAdChatListState extends State<ScreenAdChatList> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view chats')),
      );
    }

    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(const LoadUserChatsEvent()),
      child: Scaffold(
       
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserChatsLoaded) {
              final sortedChats = List<ChatModel>.from(state.chats)
                ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

              if (sortedChats.isEmpty) {
                return const Center(child: Text('No chats found'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChatBloc>().add(const LoadUserChatsEvent());
                },
                child: ListView.builder(
                  itemCount: sortedChats.length,
                  itemBuilder: (context, index) {
                    final chat = sortedChats[index];
                    return FutureBuilder<AdWithUserModel?>(
                      future: _fetchAdAndUser(context, chat.adId, chat),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(title: Text('Loading...'));
                        }
                        final adWithUser = snapshot.data;
                        if (adWithUser == null) {
                          return const ListTile(title: Text('Ad not found'));
                        }
                        return _ChatListItem(
                          chat: chat,
                          adWithUser: adWithUser,
                          currentUserId: currentUserId,
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<AdWithUserModel?> _fetchAdAndUser(
    BuildContext context,
    String adId,
    ChatModel chat,
  ) async {
    try {
      final adSnapshot = await FirebaseFirestore.instance
          .collection('car_ads')
          .doc(adId)
          .get();
      if (!adSnapshot.exists) return null;

      final ad = AdsModel.fromMap(adSnapshot.data()!, adSnapshot.id);
      final userId = chat.buyerId == FirebaseAuth.instance.currentUser?.uid
          ? chat.sellerId
          : chat.buyerId;
      final userSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      UserModel? userModel;
      if (userSnapshot.exists) {
        userModel = UserModel.fromMap(userSnapshot.data()!);
      }

      return AdWithUserModel(ad: ad, userData: userModel);
    } catch (e) {
      return null;
    }
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final AdWithUserModel adWithUser;
  final String currentUserId;

  const _ChatListItem({
    required this.chat,
    required this.adWithUser,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final ad = adWithUser.ad;
    final userData = adWithUser.userData;
    final isUnread = chat.hasUnreadMessages &&
        chat.lastMessage.isNotEmpty &&
        chat.sellerId != currentUserId;

    return ListTile(
      leading: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: ad.imageUrls.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(ad.imageUrls.first),
                  fit: BoxFit.cover,
                )
              : null,
          color: AppColors.zSecondBackground,
        ),
        child: ad.imageUrls.isEmpty
            ? const Icon(Icons.car_rental, size: 30, color: Colors.black54)
            : null,
      ),
      title: Text(
        "${ad.brand} ${ad.model} (${ad.year})",
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                userData?.fullName ?? 'Unknown User',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            chat.lastMessage.isEmpty ? 'No messages yet' : chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(context, chat.lastMessageTime),
            style: const TextStyle(fontSize: 12),
          ),
          
        ],
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenAdChat(
              chatId: chat.id,
              ad: ad,
              userData: userData,
            ),
          ),
        );

        // Refresh chats when returning from chat screen
        if (result == true && context.mounted) {
          context.read<ChatBloc>().add(const LoadUserChatsEvent());
        }
      },
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays == 2) {
      return '2 days ago';
    } else {
      return '${time.day.toString().padLeft(2, '0')} '
          '${_monthName(time.month)} '
          '${time.year}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}