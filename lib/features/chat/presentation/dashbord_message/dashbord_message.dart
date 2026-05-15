import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/features/chat/presentation/chat/chat.dart';

class ConversationPreview {
  final String name;
  final String property;
  final String message;
  final String time;
  final String avatarUrl;
  final String propertyImageUrl;
  final bool isUnread;
  final bool isSupport;
  final bool isArchived;
  final bool isPastGuest;

  const ConversationPreview({
    required this.name,
    required this.property,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.propertyImageUrl,
    this.isUnread = false,
    this.isSupport = false,
    this.isArchived = false,
    this.isPastGuest = false,
  });
}

class InboxWidget extends StatefulWidget {
  const InboxWidget({super.key});

  @override
  State<InboxWidget> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxWidget> {
  final List<ConversationPreview> messages = [
    ConversationPreview(
      name: 'Andrei Popescu',
      property: 'Apartment in Cluj-Napoca',
      message:
          'Is the wifi strong enough for video calls? I work remotely so...',
      time: '10:45 AM',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuApnjkM38ENrveUa-85f0cipgcdJ4AKmLbi7RK_7byERx8yMHRDTJiux-G0AXbE-hy0rKYhkdA2gz9L8xvwNcwMaAnPACmSEalrBqF9RbfPmHDb2oSQ986JLssg-4J0IIRLHCAPP13L78fAtnyh2cfSTr9JJ6TCSGtL8N9vW8jxhJCoCChZHa4DUkz3K52wZUOPKnAXPxhBl8MPzOpWkDXl6b3jH_OYpVx54Mm7TUqMETDY6DLlJHblT44fkTE0s-eF_fJ1jpPsLqA',
      propertyImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAnNzpLgi4eHTHBNKA9agslX7Ojuf-tmj0l6tf0W1n9YvvOvUH2OJxwDq9vRXf1q-9OpupQAxiPT0MBoFjQu5hmOY2a6L_fgU3lUuXuNyZJBZBcpetWFKtXMdh6IzXIF86KGw8qqt_dy4z7wdYyn_7wrpFwuo5wLledDqdJeb1NycJQeSGqlJXQ3iJZZjLPpKSyQ1AYBrihCME8jBjXMtRJJ74D5d0FMyRJkoiu3E2uMMq__TOdGgbmGQJq2TeNit8Q9quOIKwZrSQ',
      isUnread: true,
    ),
    ConversationPreview(
      name: 'Maria Ionescu',
      property: 'Sunny Studio Bucharest',
      message: 'Great, see you on Friday! The keys will be at the reception.',
      time: 'Yesterday',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDO-ZdvAy-psTYS5OgnBaJNT4WvIOS9NhvOFUI6WiHTdVcIrmsfBMD0mxSRiQsuJWRGysGthePJd4rRbgnwToC4vNZe64Xnwwjm1XJPxLLfF431EYynNenV_e681uXYwq2Xngrz9zgjpDnwftnaM17r0Mc7ATdWqLiu5SB0BfZsMaFXy-Hl6gL7DYbKt168ZtJtT5g3uGstk8O6sYcPJmSKzhknWPlnPiEXVl1g9mBQoJCcfnNHjCUAvAHCNpGK5Xwb92WY9ZUPKHk',
      propertyImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBVQJ8znKUsb5vG5S53w3ijsyDbymAxq4HwGvMtId2JDNBVLAPlom00r8m10v_oAo8GfG5FQyhx3EVgI2MSZFHwe7ZZqZ459whbWU9w3HMA7Q7n9d4M8Xm2XXBNTT_X-QBboDaGdhdM1oYNU1Xac7UtmyAHlb874UO83_EJWCsizv2zUiyPbqftSzZhj1f-vyT3ojgbf8TNIMapxMvRVXhdtDtYjwH1MeH2wdmIVhMr8GvE6Ru-hd-KbsNPASkRg--DR5wN0z-o9aM',
    ),
    ConversationPreview(
      name: 'Rental Support',
      property: 'System Message',
      message: 'Your booking for "Cozy Loft in Brasov" has been confirmed!',
      time: 'Oct 12',
      avatarUrl: '',
      propertyImageUrl: '',
      isSupport: true,
      isUnread: true,
    ),
    ConversationPreview(
      name: 'Alexandru Matei',
      property: 'Penthouse in Timisoara',
      message: 'No problem. Let me know if you need anything else.',
      time: 'Oct 10',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD8USW0R0xD-uy9zKMiuHOcYyrfPs8i6p-PJtsYvC3v9daldAnxm8Z2k8Bl1HLqEht5NRmiLYFriMy4kdr_VPyGfteLjFkHILUoJ8L56VqqNzLmmpiFMMiLhQE2V_fRju_L6JjuA_RMgfKbAlEj5rGelX9g-8EBvxQihMMDZ8plnJBewwrJmYs7mDgcn31UYjFhRTZYheE5TM9o22cujOMeJGwgknIOpz5F84OuaTP6lJKDg3q5WMF98BPnsIBWRj4kdPLY4NHPgTQ',
      propertyImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBf7s5ufGIbo0nD7c6CQHpQCkV76tV4arFhvI2p8Cw8B-hyTuNOLbg8ed478JrIcNHIXQS7eBDQ0ZrBBuFYTmwbJ_Xd0ETZUEpLYt7i1BiUKEOL3iUCw0rTlughFb_p40oUmdXF_XW91Kb4BRK3jhDUSIfhptkZ4ubwfEtMMNsxftqoPJ2_2FsAD8Whb2SZSgHYAW-aFy6_1uE-6H6ZSHJ6_LoTL5ZLsCgaiIgnOzxGm7h_9MXk4ZRKmpYlUNEkDp4qgY6jUbab2pk',
    ),
    ConversationPreview(
      name: 'Elena Dobre',
      property: 'Sea View Constanta',
      message: 'Thanks for the review, Elena! Safe travels.',
      time: 'Sep 28',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBvMit0cf__95wNrO1gjFLQX_2_mCEaAVkGKORj9gxJmI7869imayvAPz1EXilSa0zhc9INpYsm_qjV6kEPCZl61EPzfmI5nVUlV_4wmIaVmJ8xLsDr9bqw3T52cBb8Gqj56rOZaxvMqL2L0750bhuWu0fP8PFtp2ez506SwP4YdLmnNZcWOjcB1tD7XuRPhWFaCzkY-xz-Wx6kUjFj13pBkJHQw90F1t-OgDfB2bU4mZc1ufhXVegvibYTGOGqC_L-a_VQ0tGMRXU',
      propertyImageUrl: '',
      isPastGuest: true,
    ),
  ];

  int selectedFilter = 0;
  final List<String> filters = [AppStrings.filterAll, AppStrings.filterUnread, AppStrings.filterArchived, AppStrings.filterSupport];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = messages.where((m) => m.isUnread).length;

    return Scaffold(
      body: Container(
        color: isDark ? const Color(0xFF101822) : const Color(0xFFF6F7F8),
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.wifi,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.battery_full,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

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
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
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
                            if (filters[index] == AppStrings.filterUnread && unreadCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF136DEC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
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
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount:
                      messages.length + 1, // +1 for the "all caught up" message
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
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

                    final ConversationPreview message = messages[index];
                    return _buildMessageItem(message, isDark);
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

  Widget _buildMessageItem(ConversationPreview message, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: message.isSupport
            ? (isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9).withValues(alpha: 0.5))
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => const ChatScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unread indicator
                if (message.isUnread && !message.isSupport)
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
                      if (message.isSupport)
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF136DEC,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(
                            Icons.support_agent,
                            color: Color(0xFF136DEC),
                            size: 28,
                          ),
                        )
                      else
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(message.avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (message.propertyImageUrl.isNotEmpty &&
                          !message.isSupport)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF101822)
                                    : Colors.white,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(message.propertyImageUrl),
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
                          Text(
                            message.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            message.time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: message.isUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: message.isUnread
                                  ? const Color(0xFF136DEC)
                                  : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (message.isPastGuest)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                AppStrings.pastGuest,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          if (message.isPastGuest) const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              message.property,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: message.isUnread
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: message.isUnread
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Unread dot for support messages
                if (message.isUnread && message.isSupport)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF136DEC),
                        shape: BoxShape.circle,
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
