import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/core/models/message_model.dart' as model;
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart' as pfe_detail;
import 'package:pfe/features/chat/data/repositories/chat_repository.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';


class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserAvatar;
  final String propertyTitle;
  final String propertyImage;
  final String propertyId;
  final bool isClosed;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.propertyTitle,
    required this.propertyImage,
    required this.propertyId,
    this.isClosed = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _chatRepo = ChatRepository();
  late String _currentUserId;

  final List<String> quickReplies = [
    'Check-in time?',
    'WiFi Password',
    'Directions',
    'Parking info',
  ];

  bool isTyping = false;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false, // We'll handle bottom padding manually
        child: Container(
          color: c.background,
          child: Column(
            children: [
              // Status Bar (Simulated)

              // Header
              Container(
                color: c.card,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(40, 40),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.otherUserAvatar.isNotEmpty ? widget.otherUserAvatar : 'https://placehold.co/100x100/png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: c.border,
                              width: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: c.card,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.otherUserName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Call icon removed as requested
                  ],
                ),
              ),

              // Booking Details Bar
              Container(
                color: c.card,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.propertyImage.isNotEmpty ? widget.propertyImage : 'https://placehold.co/100x100/png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.propertyTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Oct 12 - Oct 14 • Confirmed',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Open Property Details (preview of the request property)
                        if (widget.propertyId.isNotEmpty) {
                          try {
                            final snapshot = await FirebaseDatabase.instance.ref('properties/${widget.propertyId}').get();
                            if (snapshot.exists && context.mounted) {
                              final data = Map<String, dynamic>.from(snapshot.value as Map);
                              // We need to import property_model in chat.dart for this to work
                              final property = PropertyModel.fromJson(data, widget.propertyId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pfe_detail.DetailScreen(property: property, isReadOnly: true),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not load property details')));
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Move-in Request Banner removed as requested

              // Messages Area
              Expanded(
                child: Container(
                  color: c.background,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      reverse: false,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          // Safety Message
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: c.statsBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.security,
                                  size: 14,
                                  color: c.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Always communicate and pay through the app for safety.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: c.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Date Label
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'TODAY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF9CA3AF),
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          // Booking Confirmation Message
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Booking confirmed. You can now chat with Andrei.',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: c.textSecondary,
                              ),
                            ),
                          ),

                          // Messages
                          StreamBuilder<List<model.Message>>(
                            stream: _chatRepo.getChatMessages(widget.chatId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final messages = snapshot.data!;
                              
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                }
                              });

                              return Column(
                                children: messages.map((m) => _buildMessageBubble(m, c)).toList(),
                              );
                            },
                          ),

                          // Typing Indicator
                          if (isTyping) _buildTypingIndicator(c),

                          const SizedBox(height: 80), // Spacer for input bar
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Quick Replies & Input Bar (Positioned at bottom with proper safe area)
      bottomSheet: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref('chats/${widget.chatId}').onValue,
        builder: (context, snapshot) {
          bool closed = widget.isClosed;
          bool deleted = false;
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.exists) {
              final chatData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              closed = chatData['isClosed'] == true;
            } else {
              deleted = true;
            }
          }

          if (deleted || closed) {
            return Container(
              width: double.infinity,
              color: c.card,
              padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPadding + 24),
              child: Text(
                deleted ? 'This conversation has been removed.' : 'This conversation is closed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            );
          }

          return Container(
            color: c.card,
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick Replies
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: quickReplies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _messageController.text = quickReplies[index];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: c.buttonBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: c.border,
                              ),
                            ),
                            child: Text(
                              quickReplies[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: c.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Input Bar
                Row(
                  children: [
                    // Left Icons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: c.textSecondary,
                            size: 24,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6),
                            minimumSize: const Size(36, 36),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.image,
                            color: c.textSecondary,
                            size: 24,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6),
                            minimumSize: const Size(36, 36),
                          ),
                        ),
                      ],
                    ),

                    // Text Field
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: c.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                style: TextStyle(
                                  color: c.textMain,
                                  fontSize: 14,
                                ),
                                onSubmitted: (value) => _sendMessage(),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.emoji_emotions_outlined,
                                color: c.textSecondary,
                                size: 20,
                              ),
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),

                    // Send Button
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        padding: const EdgeInsets.all(0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final text = _messageController.text;
      setState(() {
        _messageController.clear();
      });
      await _chatRepo.sendMessage(widget.chatId, _currentUserId, text);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(model.Message message, AppColorScheme c) {
    final isMe = message.senderId == _currentUserId;
    final timeFormat = DateFormat.jm().format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.otherUserAvatar.isNotEmpty ? widget.otherUserAvatar : 'https://placehold.co/100x100/png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primaryBlue
                        : (c.card),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    border: Border.all(
                      color: c.border,
                      width: 1,
                    ),
                    boxShadow: [
                      if (isMe)
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? AppColors.white : c.textMain,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 4,
                    right: isMe ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        timeFormat,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      if (isMe && message.isRead)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.done_all,
                            size: 12,
                            color: Color(0xFF136DEC),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDDG9bGTVvPrbN47nxmojhi1gVhSqCeF8A9bOJYTids21a51qsqpk62Q0KMxkD1bRXynbTGl7egmB1-fVgS0ukIWCqH8LKGSKAxUIGjg3SJPWvudYc2_W1sLJE4cMoyTznHe1NeafKT61W8fEBBLKJZsVklDlNN-jEBbNi0EvFlzzMytGTRy70NX7gRD9mQsGBG3No-DBnYjuuXE521wfwM6cBucrd0KGXlBukhy5ik-4MecCDW2F-13pZymLKn2sPdzdtgtHjXLMM',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                color: c.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _typingAnimation.value,
                      child: Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _typingAnimationController.value > 0.33
                          ? _typingAnimation.value
                          : 0.5,
                      child: Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _typingAnimationController.value > 0.66
                          ? _typingAnimation.value
                          : 0.5,
                      child: Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
