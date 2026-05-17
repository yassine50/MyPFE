import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _markAllRead(List<Map<String, dynamic>> notifs) async {
    if (_uid == null) return;
    final ref = FirebaseDatabase.instance.ref('notifications/$_uid');
    final updates = <String, dynamic>{};
    for (final n in notifs) {
      if (n['read'] != true) {
        updates['${n['id']}/read'] = true;
      }
    }
    if (updates.isNotEmpty) await ref.update(updates);
  }

  Future<void> _markRead(String notifId) async {
    if (_uid == null) return;
    await FirebaseDatabase.instance
        .ref('notifications/$_uid/$notifId/read')
        .set(true);
  }

  Future<void> _deleteNotif(String notifId) async {
    if (_uid == null) return;
    await FirebaseDatabase.instance
        .ref('notifications/$_uid/$notifId')
        .remove();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    if (_uid == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Text('Please log in to view notifications.',
              style: GoogleFonts.plusJakartaSans(color: c.textSecondary)),
        ),
      );
    }

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('notifications/$_uid').onValue,
      builder: (context, snapshot) {
        List<Map<String, dynamic>> allNotifs = [];
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final raw = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          raw.forEach((key, val) {
            if (val is Map) {
              final m = Map<String, dynamic>.from(val);
              m['id'] = key.toString();
              allNotifs.add(m);
            }
          });
          // Sort newest first
          allNotifs.sort((a, b) {
            final aT = (a['createdAt'] as int?) ?? 0;
            final bT = (b['createdAt'] as int?) ?? 0;
            return bT.compareTo(aT);
          });
        }

        final unreadCount = allNotifs.where((n) => n['read'] != true).length;
        final bookingNotifs = allNotifs
            .where((n) => n['type']?.toString().startsWith('booking') == true)
            .toList();
        final messageNotifs = allNotifs
            .where((n) => n['type']?.toString().startsWith('message') == true)
            .toList();
        final otherNotifs = allNotifs
            .where((n) =>
                n['type']?.toString().startsWith('booking') != true &&
                n['type']?.toString().startsWith('message') != true)
            .toList();

        return Scaffold(
          backgroundColor: c.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                  color: c.card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Notifications',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: c.textMain,
                                  ),
                                ),
                                if (unreadCount > 0) ...[
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: c.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$unreadCount',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (unreadCount > 0)
                            TextButton(
                              onPressed: () => _markAllRead(allNotifs),
                              child: Text(
                                'Mark all read',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: c.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TabBar(
                        controller: _tabController,
                        labelColor: c.primary,
                        unselectedLabelColor: c.textSecondary,
                        indicatorColor: c.primary,
                        indicatorWeight: 3,
                        labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        tabs: [
                          Tab(text: 'All (${allNotifs.length})'),
                          Tab(text: 'Bookings (${bookingNotifs.length})'),
                          Tab(text: 'Messages (${messageNotifs.length})'),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Content ─────────────────────────────────────────────
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child:
                              CircularProgressIndicator(color: c.primary))
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildList(allNotifs, c),
                            _buildList(bookingNotifs, c),
                            _buildList(messageNotifs + otherNotifs, c,
                                emptyLabel: 'No message notifications yet'),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(List<Map<String, dynamic>> notifs, AppColorScheme c,
      {String emptyLabel = 'No notifications yet'}) {
    if (notifs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none_outlined,
                size: 72, color: c.textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(emptyLabel,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, color: c.textSecondary)),
            const SizedBox(height: 8),
            Text('You\'re all caught up!',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 13, color: c.textSecondary.withValues(alpha: 0.6))),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifs.length,
      separatorBuilder: (_, i) =>
          Divider(height: 1, color: c.border, indent: 72),
      itemBuilder: (context, index) {
        final n = notifs[index];
        return _NotifTile(
          notif: n,
          c: c,
          onTap: () => _markRead(n['id']),
          onDismiss: () => _deleteNotif(n['id']),
        );
      },
    );
  }
}

class _NotifTile extends StatelessWidget {
  final Map<String, dynamic> notif;
  final AppColorScheme c;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotifTile({
    required this.notif,
    required this.c,
    required this.onTap,
    required this.onDismiss,
  });

  IconData get _icon {
    final type = notif['type']?.toString() ?? '';
    if (type.startsWith('booking_accepted')) return Icons.check_circle_outline;
    if (type.startsWith('booking_rejected')) return Icons.cancel_outlined;
    if (type.startsWith('booking')) return Icons.calendar_month_outlined;
    if (type.startsWith('message')) return Icons.chat_bubble_outline;
    if (type.startsWith('payment')) return Icons.payment_outlined;
    return Icons.notifications_outlined;
  }

  Color _iconColor(AppColorScheme c) {
    final type = notif['type']?.toString() ?? '';
    if (type.startsWith('booking_accepted')) return Colors.green;
    if (type.startsWith('booking_rejected')) return Colors.red;
    if (type.startsWith('booking')) return c.primary;
    if (type.startsWith('message')) return const Color(0xFF8B5CF6);
    if (type.startsWith('payment')) return const Color(0xFFF59E0B);
    return c.textSecondary;
  }

  String get _timeAgo {
    final ts = (notif['createdAt'] as int?) ?? 0;
    if (ts == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notif['read'] == true;
    final title = notif['title']?.toString() ?? 'Notification';
    final body = notif['body']?.toString() ?? '';

    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.shade400,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isRead ? Colors.transparent : c.primary.withValues(alpha: 0.04),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon bubble
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconColor(c).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, size: 22, color: _iconColor(c)),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight:
                                  isRead ? FontWeight.w500 : FontWeight.bold,
                              color: c.textMain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _timeAgo,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: c.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Unread dot
              if (!isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: c.primary, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
