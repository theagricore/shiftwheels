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

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.chatId));
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() {
    context.read<ChatBloc>().add(
          MarkMessagesReadEvent(chatId: widget.chatId, userId: currentUserId),
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleReply(MessageModel message) {
    setState(() {
      _replyingToMessage = message;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUser?.fullName ?? 'Unknown User'),
            if (widget.ad != null)
              Text(
                '${widget.ad!.brand} ${widget.ad!.model}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        backgroundColor: AppColors.zPrimaryColor,
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MessagesLoaded) {
                    return StreamBuilder<List<MessageModel>>(
                      stream: state.messages,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final messages = snapshot.data!;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                          }
                        });

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: messages.length + _calculateDateTags(messages),
                          itemBuilder: (context, index) {
                            final dateTagIndex = _getDateTagIndex(messages, index);
                            if (dateTagIndex != null) {
                              return _buildDateTag(messages[dateTagIndex].timestamp);
                            }

                            final messageIndex = index - _calculateDateTagsBefore(messages, index);
                            if (messageIndex < 0 || messageIndex >= messages.length) {
                              return const SizedBox.shrink();
                            }

                            final message = messages[messageIndex];
                            final isMe = message.senderId == currentUserId;

                            // Skip rendering if message is deleted and not from current user
                            if (message.isDeleted && !isMe) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onLongPress: () {
                                if (isMe && !message.isDeleted) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => _buildMessageOptions(message, isMe),
                                  );
                                }
                              },
                              child: Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColors.zPrimaryColor
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                                      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      if (message.replyToContent != null && !message.isDeleted)
                                        Container(
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
                                      Text(
                                        message.displayContent,
                                        style: TextStyle(
                                          color: isMe ? Colors.white : Colors.black,
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
                                          if (isMe && !message.isDeleted)
                                            _buildMessageStatus(message.status),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink(); // Avoid showing indicator for other states
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageOptions(MessageModel message, bool isMe) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
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
          if (isMe)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                context.read<ChatBloc>().add(DeleteMessageEvent(
                  chatId: widget.chatId,
                  messageId: message.id,
                ));
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  int _calculateDateTags(List<MessageModel> messages) {
    if (messages.isEmpty) return 0;
    if (messages.length == 1) return 1;
    var count = 1;
    var lastDate = DateFormat('yyyy-MM-dd').format(messages[0].timestamp);
    for (var i = 1; i < messages.length; i++) {
      var currentDate = DateFormat('yyyy-MM-dd').format(messages[i].timestamp);
      if (currentDate != lastDate) {
        count++;
        lastDate = currentDate;
      }
    }
    return count;
  }

  int _calculateDateTagsBefore(List<MessageModel> messages, int index) {
    if (messages.isEmpty || index <= 0) return 0;
    var count = 1;
    var lastDate = DateFormat('yyyy-MM-dd').format(messages[0].timestamp);
    var messageIndex = 0;
    for (var i = 1; i < messages.length && messageIndex < index; i++) {
      var currentDate = DateFormat('yyyy-MM-dd').format(messages[i].timestamp);
      if (currentDate != lastDate) {
        count++;
        lastDate = currentDate;
      }
      messageIndex++;
      if (messageIndex + count >= index) break;
    }
    return count;
  }

  int? _getDateTagIndex(List<MessageModel> messages, int index) {
    if (messages.isEmpty) return null;
    var dateTagCount = 0;
    var messageIndex = 0;
    var lastDate = DateFormat('yyyy-MM-dd').format(messages[0].timestamp);

    if (index == 0) return 0;

    for (var i = 1; i < messages.length; i++) {
      var currentDate = DateFormat('yyyy-MM-dd').format(messages[i].timestamp);
      if (currentDate != lastDate) {
        dateTagCount++;
        if (index == messageIndex + dateTagCount) return i;
        lastDate = currentDate;
      }
      messageIndex++;
      if (messageIndex + dateTagCount >= index) break;
    }
    return null;
  }

  Widget _buildDateTag(DateTime timestamp) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(timestamp);
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          formattedDate,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildMessageStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 12, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.check_circle, size: 12, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.check_circle, size: 12, color: Colors.blue);
    }
  }

  Widget _buildMessageInput() {
    return Column(
      children: [
        if (_replyingToMessage != null)
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Replying to ${_replyingToMessage!.senderId == currentUserId ? "yourself" : widget.otherUser?.fullName ?? "Unknown"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _replyingToMessage!.displayContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.zBackGround,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.zBackGround,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            fillColor: AppColors.zBackGround,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file, color: AppColors.zBackGround),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.zPrimaryColor,
                ),
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

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}