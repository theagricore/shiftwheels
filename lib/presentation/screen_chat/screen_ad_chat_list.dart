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

class ScreenAdChatList extends StatefulWidget {
  const ScreenAdChatList({super.key});

  @override
  State<ScreenAdChatList> createState() => _ScreenAdChatListState();
}

class _ScreenAdChatListState extends State<ScreenAdChatList> {
  Stream<List<ChatModel>>? _chatsStream;
  List<ChatModel> _chats = [];

  @override
  void initState() {
    super.initState();
    // Load chats when the screen initializes
    context.read<ChatBloc>().add(const LoadUserChatsStreamEvent());
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view chats')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: AppColors.zPrimaryColor,
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is UserChatsStreamLoaded) {
            // Update the local chats stream and listen to it
            _chatsStream = state.chatsStream;
            _chatsStream?.listen((chats) {
              setState(() {
                _chats = chats;
              });
            });
          } else if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ChatLoading && _chats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_chats.isEmpty) {
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            itemCount: _chats.length,
            itemBuilder: (context, index) {
              final chat = _chats[index];
              return FutureBuilder<AdWithUserModel?>(
                future: _fetchAdAndUser(chat),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  final adWithUser = snapshot.data;
                  if (adWithUser == null) {
                    return const ListTile(
                      title: Text('Chat information not available'),
                    );
                  }
                  return _ChatListItem(
                    chat: chat,
                    adWithUser: adWithUser,
                    currentUserId: currentUserId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<AdWithUserModel?> _fetchAdAndUser(ChatModel chat) async {
    try {
      // Fetch the ad
      final adSnapshot =
          await FirebaseFirestore.instance
              .collection('car_ads')
              .doc(chat.adId)
              .get();

      if (!adSnapshot.exists) return null;

      final ad = AdsModel.fromMap(adSnapshot.data()!, adSnapshot.id);

      // Determine the other user's ID
      final otherUserId =
          chat.buyerId == FirebaseAuth.instance.currentUser?.uid
              ? chat.sellerId
              : chat.buyerId;

      // Fetch the other user's details
      final userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(otherUserId)
              .get();

      UserModel? userModel;
      if (userSnapshot.exists) {
        userModel = UserModel.fromMap(userSnapshot.data()!);
      }

      return AdWithUserModel(ad: ad, userData: userModel);
    } catch (e) {
      debugPrint('Error fetching ad and user: $e');
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
    final isUnread = chat.hasUnreadMessages && chat.sellerId != currentUserId;

    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image:
              ad.imageUrls.isNotEmpty
                  ? DecorationImage(
                    image: NetworkImage(ad.imageUrls.first),
                    fit: BoxFit.cover,
                  )
                  : null,
          color: Colors.grey[200],
        ),
        child:
            ad.imageUrls.isEmpty
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
          Text(
            userData?.fullName ?? 'Unknown User',
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            chat.lastMessage.isEmpty ? 'No messages yet' : chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isUnread ? Colors.blue : Colors.grey,
              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(chat.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: isUnread ? Colors.blue : Colors.grey,
            ),
          ),
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ScreenAdChat(chatId: chat.id, ad: ad, userData: userData),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
