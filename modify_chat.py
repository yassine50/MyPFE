import re

with open('lib/features/chat/presentation/chat/chat.dart', 'r') as f:
    content = f.read()

# 1. Add imports
imports = """import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/core/models/message_model.dart' as model;
import 'package:pfe/features/chat/data/repositories/chat_repository.dart';
import 'package:intl/intl.dart';
"""
content = re.sub(r"import 'package:flutter/material.dart';.*?import 'package:pfe/core/theme/app_theme.dart';", imports, content, flags=re.DOTALL)

# 2. Remove local Message class
content = re.sub(r'class Message \{.*?\n\}\n\n', '', content, flags=re.DOTALL)

# 3. Update ChatScreen class
chat_screen_class = """class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserAvatar;
  final String propertyTitle;
  final String propertyImage;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.propertyTitle,
    required this.propertyImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
"""
content = re.sub(r'class ChatScreen extends StatefulWidget \{.*?\n\}\n\n', chat_screen_class + '\n', content, flags=re.DOTALL)

# 4. Update _ChatScreenState vars
chat_screen_state_vars = """class _ChatScreenState extends State<ChatScreen>
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
"""
content = re.sub(r'class _ChatScreenState extends State<ChatScreen>\n    with SingleTickerProviderStateMixin \{.*?late Animation<double> _typingAnimation;\n', chat_screen_state_vars, content, flags=re.DOTALL)

# 5. Update initState
init_state_start = """  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
"""
content = re.sub(r'  @override\n  void initState\(\) \{\n    super\.initState\(\);', init_state_start, content, count=1)

# 6. Replace header avatar & name
content = re.sub(r"'https://lh3.googleusercontent.com/aida-public/[^']*'", "widget.otherUserAvatar.isNotEmpty ? widget.otherUserAvatar : 'https://placehold.co/100x100/png'", content, count=1)
content = re.sub(r"'Andrei'", "widget.otherUserName", content)

# 7. Replace property image & title
content = re.sub(r"'https://lh3.googleusercontent.com/aida-public/[^']*'", "widget.propertyImage.isNotEmpty ? widget.propertyImage : 'https://placehold.co/100x100/png'", content, count=1)
content = re.sub(r"'Apartment in Brașov'", "widget.propertyTitle", content)

# 8. Replace messages area with StreamBuilder
messages_area = """                          // Messages
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
"""
content = re.sub(r'                          // Messages\n                          \.\.\.messages\.map\(\n                            \(message\) => _buildMessageBubble\(message, c\),\n                          \),\n', messages_area, content)

# 9. Update _buildMessageBubble signature and logic
build_bubble = """  Widget _buildMessageBubble(model.Message message, AppColorScheme c) {
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
  }"""
content = re.sub(r'  Widget _buildMessageBubble\(Message message, AppColorScheme c\) \{.*?\n  Widget _buildTypingIndicator', build_bubble + '\n\n  Widget _buildTypingIndicator', content, flags=re.DOTALL)

# 10. Update quick replies and _sendMessage
quick_replies_tap = """                        setState(() {
                          _messageController.text = quickReplies[index];
                        });"""
content = re.sub(r'                        setState\(\(\) \{.*?_scrollToBottom\(\);\n                        \}\);', quick_replies_tap, content, flags=re.DOTALL)

send_message = """  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final text = _messageController.text;
      setState(() {
        _messageController.clear();
      });
      await _chatRepo.sendMessage(widget.chatId, _currentUserId, text);
      _scrollToBottom();
    }
  }"""
content = re.sub(r'  void _sendMessage\(\) \{.*?\n  \}\n\n  void _scrollToBottom', send_message + '\n\n  void _scrollToBottom', content, flags=re.DOTALL)

with open('lib/features/chat/presentation/chat/chat.dart', 'w') as f:
    f.write(content)
