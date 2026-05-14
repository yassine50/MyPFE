import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final bool isTyping;

  const Message({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
    this.isTyping = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> messages = [
    Message(
      text:
          'Hi! Looking forward to hosting you. What time do you expect to arrive?',
      isMe: false,
      time: '10:42 AM',
    ),
    Message(
      text: 'Hi Andrei, thanks! We should be there around 14:00.',
      isMe: true,
      time: '10:45 AM',
      isRead: true,
    ),
  ];
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
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCBpameCyzkUPvQSSEn0v_d6dZLX4VcW8QhBNoEkEZuVMVf0XDBlaShLwVPFSAZNCuSP6VGpl5n-jysc89pJ9vk5tXxOq_--6BjdATRLrb3PtzIyZF9UWV8wYFpPoTAEiGWpBG9yfwKPj7C2EyhNLWzKDoYDfm6DkcOPCxjtyDV-URZuLzr-qCJmKty8L0cW7RpYjnY8N5CpoAosek4_fRXQkf9AAa8XohNCKu17AECLvHyly-vZQta2qSo9qz96GQG4vUh7Yo90XY',
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
                            'Andrei',
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        size: 20,
                        color: Color(0xFF136DEC),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: c.buttonBg,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40),
                      ),
                    ),
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
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD_v7iI74ZfEtDLziDe1GQv4FAT10Do2Io0EREAeBZhXaH0ctlRTBbhaZxukBuK0AUhsMpymfA4dGVdaS0glG4v002vw5cJgpNnjCptfMl9yvCMxSKN8iWbIb9d7NYDLWood7_HT6jiDrDV5OHDOEsYWaC6lVYUBKBHDSkKU86lVO-Mus3RCQRvhFOzBONh1ni9N4wvmKS7asoegS2wx4NEjKXatF-BEXRpeTVbUpFNUQd0EmbOXPupLBT5_EDyVzstiCS4GCFmBKk',
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
                            'Apartment in Brașov',
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
                      onTap: () {},
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

              // Move-in Request Banner
              Container(
                color: c.segmentBg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'READY TO MOVE IN?',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Send a request to finalize.',
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.key, size: 16),
                      label: const Text('Move-in Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                      ),
                    ),
                  ],
                ),
              ),

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
                          ...messages.map(
                            (message) => _buildMessageBubble(message, c),
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
      bottomSheet: Container(
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
                          messages.add(
                            Message(
                              text: quickReplies[index],
                              isMe: true,
                              time: 'Now',
                              isRead: false,
                            ),
                          );
                          _messageController.clear();
                          _scrollToBottom();
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
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(
          Message(
            text: _messageController.text,
            isMe: true,
            time: 'Now',
            isRead: false,
          ),
        );
        _messageController.clear();
        isTyping = true;
        _scrollToBottom();

        // Simulate typing response
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isTyping = false;
            messages.add(
              Message(
                text:
                    'Great! See you at 14:00. The keys will be at the reception.',
                isMe: false,
                time: 'Now',
              ),
            );
            _scrollToBottom();
          });
        });
      });
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

  Widget _buildMessageBubble(Message message, AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBqg9c-cOoBSu4rfX2yN-02ZH70rYjEz2eqiogWAMmx1YunziQyy0L18Hf_qdqEnMeuP5g3RsN6yJtj3-3Nt2ENEpAqqoDQqd5BVnH7l3ynB1sRYBK7m5Of9_QQKzX83EZApcq01AswYLqm4mWYQOeTemxIrLJqig5rSSCtuA2_Q1eOG725UHn6iC7q4cSkJv2Jt4YeP5KIg15oSHgDRw6vT0S1RuabeuzcPMgFo4lH-JyZIctn7p0TRpjIq5NEfKAYFrMvvzRHECM',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? AppColors.primaryBlue
                        : (c.card),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: message.isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    border: Border.all(
                      color: c.border,
                      width: 1,
                    ),
                    boxShadow: [
                      if (message.isMe)
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isMe ? AppColors.white : c.textMain,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(
                    left: message.isMe ? 0 : 4,
                    right: message.isMe ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: message.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      if (message.isMe && message.isRead)
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
