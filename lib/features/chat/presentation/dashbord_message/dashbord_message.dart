import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/features/chat/presentation/chat/chat.dart';
import 'package:pfe/features/chat/data/repositories/chat_repository.dart';
import 'package:pfe/core/models/conversation_model.dart';
import 'package:intl/intl.dart';

class InboxWidget extends StatefulWidget {
  final bool isRenter;
  
  const InboxWidget({
    super.key,
    this.isRenter = true,
  });

  @override
  State<InboxWidget> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxWidget> {
  int selectedFilter = 0;
  final List<String> filters = [AppStrings.filterAll, AppStrings.filterUnread, AppStrings.filterArchived, AppStrings.filterSupport];
  final _chatRepo = ChatRepository();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view your messages.')),
      );
    }

    return Scaffold(
      body: Container(
        color: isDark ? const Color(0xFF101822) : const Color(0xFFF6F7F8),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.inbox,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(
                        Icons.tune,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.searchMessages,
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Chips
              SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, top: 8),
                      child: ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          filters[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selectedFilter == index
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: selectedFilter == index
                                ? (isDark
                                      ? const Color(0xFF136DEC)
                                      : Colors.white)
                                : (isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[600]),
                          ),
                        ),
                        selected: selectedFilter == index,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = index;
                          });
                        },
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        selectedColor: isDark
                            ? Colors.white
                            : const Color(0xFF136DEC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Messages List
              Expanded(
                child: StreamBuilder<List<Conversation>>(
                  stream: widget.isRenter 
                      ? _chatRepo.getGuestChats(currentUser.uid)
                      : _chatRepo.getHostChats(currentUser.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading chats'));
                    }
                    final chats = snapshot.data ?? [];
                    if (chats.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: chats.length + 1, // +1 for the "all caught up" message
                      itemBuilder: (context, index) {
                        if (index == chats.length) {
                          return Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                AppStrings.allCaughtUp,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        final Conversation conversation = chats[index];
                        return _ConversationItem(
                          conversation: conversation,
                          currentUserId: currentUser.uid,
                          isDark: isDark,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF136DEC),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_comment, color: Colors.white, size: 24),
      ),
    );
  }
}

class _ConversationItem extends StatefulWidget {
  final Conversation conversation;
  final String currentUserId;
  final bool isDark;

  const _ConversationItem({
    required this.conversation,
    required this.currentUserId,
    required this.isDark,
  });

  @override
  State<_ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  String _otherUserName = 'Loading...';
  String _otherUserAvatar = '';
  String _propertyTitle = 'Property';
  String _propertyImage = '';
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final otherUserId = widget.conversation.hostId == widget.currentUserId
        ? widget.conversation.guestId
        : widget.conversation.hostId;
    
    // Fallback names
    setState(() {
      _otherUserName = 'User';
    });
    
    // Fetch user details (Assuming users are stored in 'users' node)
    try {
      final userSnapshot = await FirebaseDatabase.instance.ref('users/$otherUserId').get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _otherUserName = userData['name'] ?? userData['firstName'] ?? 'User';
          _otherUserAvatar = userData['profileImage'] ?? userData['photoUrl'] ?? '';
        });
      }
    } catch (_) {}

    // Fetch property details
    try {
      final propertySnapshot = await FirebaseDatabase.instance.ref('properties/${widget.conversation.propertyId}').get();
      if (propertySnapshot.exists) {
        final propData = propertySnapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _propertyTitle = propData['title'] ?? 'Property';
          final images = propData['images'] as List<dynamic>?;
          if (images != null && images.isNotEmpty) {
            _propertyImage = images[0].toString();
          }
        });
      }
    } catch (_) {}

    // Count unread messages from the other user
    try {
      final otherUserId = widget.conversation.hostId == widget.currentUserId
          ? widget.conversation.guestId
          : widget.conversation.hostId;
      final msgsSnapshot = await FirebaseDatabase.instance
          .ref('chats/${widget.conversation.id}/messages')
          .get();
      if (msgsSnapshot.exists) {
        final data = msgsSnapshot.value as Map<dynamic, dynamic>;
        int count = 0;
        data.forEach((key, value) {
          final msg = value as Map<dynamic, dynamic>;
          if (msg['senderId'] == otherUserId && msg['isRead'] == false) {
            count++;
          }
        });
        setState(() => _unreadCount = count);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // For formatting timestamp
    final timeFormat = DateFormat.jm().format(widget.conversation.updatedAt);
    
    // isUnread: track whether conversation has unread messages (based on unreadCount)
    final bool isUnread = _unreadCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: widget.isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Mark messages as read when opening the chat
            if (_unreadCount > 0) {
              final chatRepo = ChatRepository();
              await chatRepo.markMessagesAsRead(widget.conversation.id, widget.currentUserId);
              setState(() => _unreadCount = 0);
            }
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => ChatScreen(
                    chatId: widget.conversation.id,
                    otherUserName: _otherUserName,
                    otherUserAvatar: _otherUserAvatar,
                    propertyTitle: _propertyTitle,
                    propertyImage: _propertyImage,
                    propertyId: widget.conversation.propertyId,
                    isClosed: widget.conversation.isClosed,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUnread)
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF136DEC),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 4),

                // Avatar/Icon
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 16),
                  child: Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                          image: _otherUserAvatar.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_otherUserAvatar),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _otherUserAvatar.isEmpty
                            ? Icon(Icons.person, color: Colors.grey[600])
                            : null,
                      ),
                      if (_propertyImage.isNotEmpty)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: widget.isDark
                                    ? const Color(0xFF101822)
                                    : Colors.white,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(_propertyImage),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _otherUserName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark ? Colors.white : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            timeFormat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isUnread
                                  ? const Color(0xFF136DEC)
                                  : (widget.isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _propertyTitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isDark
                              ? Colors.grey[400]
                              : Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.conversation.lastMessage.isNotEmpty 
                            ? widget.conversation.lastMessage 
                            : 'No messages yet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: isUnread
                              ? (widget.isDark ? Colors.white : Colors.black)
                              : (widget.isDark ? Colors.grey[400] : Colors.grey[600]),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Unread badge
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF136DEC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
