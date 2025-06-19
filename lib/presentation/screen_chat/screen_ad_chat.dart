import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/message_model.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_chat/chat_bloc/chat_bloc.dart';

class ScreenAdChat extends StatefulWidget {
  final String chatId;
  final UserModel? otherUser;
  final AdsModel? ad;

  const ScreenAdChat({
    super.key,
    required this.chatId,
    required this.otherUser,
    required this.ad,
  });

  @override
  State<ScreenAdChat> createState() => _ScreenAdChatState();
}

class _ScreenAdChatState extends State<ScreenAdChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  MessageModel? _replyingToMessage;

  final Map<String, GlobalKey> _messageKeys = {};
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.chatId));
    _markMessagesAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _markMessagesAsRead() {
    context.read<ChatBloc>().add(
      MarkMessagesReadEvent(chatId: widget.chatId, userId: currentUserId),
    );
  }

  void _handleReply(MessageModel message) {
    setState(() => _replyingToMessage = message);
  }

  void _cancelReply() {
    setState(() => _replyingToMessage = null);
  }

  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _highlightedMessageId = messageId);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightedMessageId = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is MessagesLoaded) {
            _markMessagesAsRead();
          }
        },
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.zPrimaryColor,
      elevation: 2,
      leading: const BackButton(color: Colors.white),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              widget.otherUser?.fullName?[0].toUpperCase() ?? "?",
              style: const TextStyle(color: AppColors.zPrimaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.otherUser?.fullName ?? 'Unknown User',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (widget.ad != null)
                Text(
                  '${widget.ad!.brand} ${widget.ad!.model}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is MessagesLoading && state.isInitialLoad) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MessagesLoaded) {
          return StreamBuilder<List<MessageModel>>(
            stream: state.messages,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              final messages = snapshot.data!;
              final chatItems = _buildChatItems(messages);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                }
              });

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: chatItems.length,
                itemBuilder: (context, index) {
                  final item = chatItems[index];
                  if (item is String) {
                    return _buildDateTag(item);
                  } else if (item is MessageModel) {
                    final isMe = item.senderId == currentUserId;
                    final key = _messageKeys[item.id] ??= GlobalKey();
                    return Container(
                      key: key,
                      decoration: BoxDecoration(
                        color: item.id == _highlightedMessageId 
                          ? Colors.yellow.shade100 
                          : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildMessageWidget(item, isMe),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

Widget _buildDateTag(String dateText) {
  return Center(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        dateText,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    ),
  );
}

  List<dynamic> _buildChatItems(List<MessageModel> messages) {
    final chatItems = <dynamic>[];
    String? lastDate;
    for (final message in messages) {
      final msgDate = DateFormat('yyyy-MM-dd').format(message.timestamp);
      if (lastDate != msgDate) {
        chatItems.add(_formatDateTag(message.timestamp));
        lastDate = msgDate;
      }
      chatItems.add(message);
    }
    return chatItems;
  }

  Widget _buildMessageWidget(MessageModel message, bool isMe) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message, isMe),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                      colors: [AppColors.zOrange, AppColors.zPrimaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [AppColors.zGrey, Color(0xFFE2E2E2)],
                    ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.replyToContent != null && !message.isDeleted)
                  GestureDetector(
                    onTap: () => _scrollToMessage(message.replyToMessageId ?? ''),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message.replyToContent!,
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                Text(
                  message.displayContent,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontStyle: message.isDeleted ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (isMe && !message.isDeleted) _buildMessageStatus(message.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(MessageModel message, bool isMe) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                _handleReply(message);
                Navigator.pop(context);
              },
            ),
            if (isMe && !message.isDeleted)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  context.read<ChatBloc>().add(
                    DeleteMessageEvent(
                      chatId: widget.chatId,
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
  }

  Widget _buildMessageInput() {
    return Column(
      children: [
        if (_replyingToMessage != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                left: BorderSide(color: AppColors.zPrimaryColor, width: 4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Replying to ${_replyingToMessage!.senderId == currentUserId ? "yourself" : widget.otherUser?.fullName ?? "Unknown"}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Text(
                        _replyingToMessage!.displayContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _cancelReply,
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.zPrimaryColor,width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                              fillColor: AppColors.zWhite,
                              
                            ),
                            maxLines: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.zPrimaryColor,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      context.read<ChatBloc>().add(
                        SendMessageEvent(
                          chatId: widget.chatId,
                          senderId: currentUserId,
                          content: _messageController.text.trim(),
                          replyToMessageId: _replyingToMessage?.id,
                          replyToContent: _replyingToMessage?.displayContent,
                        ),
                      );
                      _messageController.clear();
                      _cancelReply();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTag(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays >= 1) {
      return DateFormat('MMM dd, hh:mm a').format(timestamp);
    } else {
      return DateFormat('hh:mm a').format(timestamp);
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inDays >= 1) {
      return DateFormat('MMM dd, hh:mm a').format(timestamp);
    } else {
      return DateFormat('hh:mm a').format(timestamp);
    }
  }

  Widget _buildMessageStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
    }
  }
}