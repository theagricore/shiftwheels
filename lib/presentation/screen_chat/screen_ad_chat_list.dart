import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';
import 'package:shiftwheels/presentation/screen_chat/screen_ad_chat.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScreenAdChatList extends StatefulWidget {
  const ScreenAdChatList({super.key});

  @override
  State<ScreenAdChatList> createState() => _ScreenAdChatListState();
}

class _ScreenAdChatListState extends State<ScreenAdChatList> {
  StreamSubscription<ChatState>? _blocSubscription;
  StreamSubscription<List<ChatModel>>? _chatsSubscription;
  List<ChatModel> _chats = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  void dispose() {
    _blocSubscription?.cancel();
    _chatsSubscription?.cancel();
    super.dispose();
  }

  void _loadChats() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _chats = [];
      });

      // Cancel any existing subscriptions
      _blocSubscription?.cancel();
      _chatsSubscription?.cancel();

      // Initialize BLoC and load chats
      context.read<ChatBloc>().add(LoadChatsEvent(currentUserId));

      // Listen to BLoC state changes
      _blocSubscription = context.read<ChatBloc>().stream.listen((state) {
        if (state is ChatsLoaded) {
          // Cancel previous chats subscription if exists
          _chatsSubscription?.cancel();
          
          // Subscribe to the chats stream
          _chatsSubscription = state.chats.listen((chats) {
            if (mounted) {
              setState(() {
                _chats = chats;
                _isLoading = false;
              });
            }
          }, onError: (error) {
            if (mounted) {
              setState(() {
                _errorMessage = error.toString();
                _isLoading = false;
              });
            }
          });
        } else if (state is ChatError) {
          if (mounted) {
            setState(() {
              _errorMessage = state.message;
              _isLoading = false;
            });
          }
        } else if (state is ChatLoading) {
          if (mounted) {
            setState(() {
              _isLoading = true;
            });
          }
        }
      });
    }
  }

  void _refreshChats() {
    _loadChats();
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
            onPressed: _refreshChats,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _chats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshChats,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_chats.isEmpty) {
      return const Center(
        child: Text(
          'No chats yet',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _refreshChats(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
          final otherUser = chat.sellerId == currentUserId 
              ? chat.buyer 
              : chat.seller;
          final ad = chat.ad;
          final lastMessage = chat.lastMessage;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
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
                ).then((_) => _refreshChats());
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.zPrimaryColor,
                      radius: 24,
                      child: Text(
                        otherUser?.fullName?.substring(0, 1) ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otherUser?.fullName ?? 'Unknown User',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (ad != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${ad.brand} ${ad.model}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (lastMessage != null) ...[
                            const SizedBox(height: 4),
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
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (lastMessage != null)
                          Text(
                            timeago.format(lastMessage.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}