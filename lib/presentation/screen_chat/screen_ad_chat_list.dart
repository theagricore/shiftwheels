import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/chat_model.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/chat_card_widget.dart';
import 'package:shiftwheels/presentation/screen_chat/widget/shimmer_card.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildChatBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Messages'),
      backgroundColor: AppColors.zPrimaryColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadChats,
        ),
      ],
    );
  }

  Widget _buildChatBody() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatsLoading) return _buildShimmerLoader();
        if (state is ChatsLoaded) return _buildChatStream(state.chats);
        return const SizedBox();
      },
    );
  }

  Widget _buildChatStream(Stream<List<ChatModel>> chatStream) {
    return StreamBuilder<List<ChatModel>>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _buildShimmerLoader();

        final chats = snapshot.data!;
        if (chats.isEmpty) {
          return const Center(child: Text('No chats yet'));
        }

        return ChatCardWidget(
          chats: chats,
          currentUserId: _currentUserId,
          onRefresh: _loadChats,
        );
      },
    );
  }

  Widget _buildShimmerLoader() {
    return const ShimmerCard();
  }
}