import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/features/host/presentation/host/add_listing/add_listing_step1_type.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:intl/intl.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  final Map<String, PropertyModel> _hostProperties = {};
  bool _loadingProperties = true;
  String _hostPhotoUrl = '';
  String _hostFirstName = 'Host';

  final _uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load host profile
    final snap = await FirebaseDatabase.instance.ref('users/$_uid').get();
    if (snap.exists && snap.value != null) {
      final d = Map<String, dynamic>.from(snap.value as Map);
      _hostPhotoUrl = d['profileImage'] as String? ?? '';
      final full = d['fullName'] as String? ?? '';
      _hostFirstName = full.split(' ').first.isNotEmpty ? full.split(' ').first : 'Host';
    }

    // Load host's properties to match bookings
    try {
      final all = await PropertyRepository().fetchProperties();
      for (final p in all) {
        if (p.hostId == _uid) _hostProperties[p.id] = p;
      }
    } catch (_) {}

    if (mounted) setState(() => _loadingProperties = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(c),
            if (_loadingProperties)
              Expanded(child: Center(child: CircularProgressIndicator(color: c.primary)))
            else
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      _buildPerformance(c),
                      _buildQuickActions(c),
                      _buildActiveReservations(c),
                      _buildRecentMessages(c),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────────────────
  Widget _buildTopBar(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(color: c.card, border: Border(bottom: BorderSide(color: c.border))),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.border),
              color: c.statsBg,
              image: _hostPhotoUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(_hostPhotoUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: _hostPhotoUrl.isEmpty
                ? Icon(Icons.person, size: 18, color: c.textSecondary) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
                Text(_hostFirstName, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
              ],
            ),
          ),
          _buildNotificationBell(c),
        ],
      ),
    );
  }

  // ─── Notification Bell ────────────────────────────────────────────────────
  Widget _buildNotificationBell(AppColorScheme c) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').onValue,
      builder: (context, snap) {
        int pending = 0;
        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((_, val) {
            final b = Map<String, dynamic>.from(val as Map);
            final pid = b['propertyId']?.toString() ?? '';
            if (_hostProperties.containsKey(pid) &&
                b['guestId']?.toString() != _uid &&
                b['status'] == 'pending') {
              pending++;
            }
          });
        }
        return Stack(
          children: [
            IconButton(
              onPressed: () => _showNotificationsSheet(c),
              icon: Icon(Icons.notifications_outlined, color: c.textMain, size: 26),
            ),
            if (pending > 0)
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle,
                      border: Border.all(color: c.card, width: 2)),
                  child: Center(child: Text('$pending',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showNotificationsSheet(AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _NotificationsSheet(hostProperties: _hostProperties, uid: _uid, c: c),
    );
  }

  // ─── Performance Section ──────────────────────────────────────────────────
  Widget _buildPerformance(AppColorScheme c) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').onValue,
      builder: (context, snap) {
        double earnings = 0;
        int total = 0, accepted = 0;
        final now = DateTime.now();

        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((_, val) {
            final b = Map<String, dynamic>.from(val as Map);
            final pid = b['propertyId']?.toString() ?? '';
            if (!_hostProperties.containsKey(pid)) return;
            if (b['guestId']?.toString() == _uid) return;
            total++;
            final status = b['status']?.toString() ?? '';
            if (status == 'accepted' || status == 'confirmed') {
              accepted++;
            }
            final ts = b['createdAt'];
            if (ts != null) {
              final date = ts is int
                  ? DateTime.fromMillisecondsSinceEpoch(ts)
                  : DateTime.tryParse(ts.toString());
              if (date != null && date.month == now.month && date.year == now.year) {
                if (status == 'accepted' || status == 'confirmed') {
                  earnings += (b['totalPrice'] as num?)?.toDouble() ?? 0;
                }
              }
            }
          });
        }

        final occupancy = total > 0 ? (accepted / total * 100).round() : 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.performanceOverview,
                  style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.bold, color: c.textMain)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _statCard(
                    AppStrings.monthlyEarnings, CurrencyFormatter.format(earnings),
                    '$accepted accepted this month', true, c)),
                  const SizedBox(width: 16),
                  Expanded(child: _statCard(
                    AppStrings.occupancyRate, '$occupancy%',
                    '$accepted / $total bookings', occupancy >= 50, c)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String title, String value, String sub, bool positive, AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, color: c.textMain)),
          const SizedBox(height: 6),
          Row(children: [
            Icon(positive ? Icons.trending_up : Icons.trending_down,
                color: positive ? Colors.green : Colors.red, size: 14),
            const SizedBox(width: 4),
            Expanded(child: Text(sub,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: positive ? Colors.green : Colors.red),
                overflow: TextOverflow.ellipsis)),
          ]),
        ],
      ),
    );
  }

  // ─── Quick Actions ────────────────────────────────────────────────────────
  Widget _buildQuickActions(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddListingStep1TypeScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            icon: const Icon(Icons.add_box, size: 20),
            label: Text(AppStrings.btnNewListing,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
          )),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing calendar...'), duration: Duration(seconds: 1))),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary.withValues(alpha: 0.1), foregroundColor: c.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            icon: const Icon(Icons.sync, size: 20),
            label: Text(AppStrings.btnSyncCalendar,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
          )),
        ],
      ),
    );
  }

  // ─── Active Reservations ──────────────────────────────────────────────────
  Widget _buildActiveReservations(AppColorScheme c) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').onValue,
      builder: (context, snap) {
        final List<Map<String, dynamic>> active = [];

        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((key, val) {
            final b = Map<String, dynamic>.from(val as Map);
            final pid = b['propertyId']?.toString() ?? '';
            if (!_hostProperties.containsKey(pid)) return;
            if (b['guestId']?.toString() == _uid) return;
            final status = b['status']?.toString() ?? '';
            if (status == 'accepted' || status == 'confirmed' || status == 'pending') {
              active.add({'_key': key, ...b});
            }
          });

          // Sort by createdAt descending
          active.sort((a, b) {
            final ta = (a['createdAt'] as num?)?.toInt() ?? 0;
            final tb = (b['createdAt'] as num?)?.toInt() ?? 0;
            return tb.compareTo(ta);
          });
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.activeReservations,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 20, fontWeight: FontWeight.bold, color: c.textMain)),
                  Text('${active.length} total',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary)),
                ],
              ),
              const SizedBox(height: 12),
              if (active.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: c.card, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.border),
                  ),
                  child: Center(child: Column(children: [
                    Icon(Icons.calendar_today_outlined, size: 40, color: c.textSecondary.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text('No active reservations',
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, color: c.textSecondary)),
                  ])),
                )
              else
                ...active.take(4).map((b) {
                  final pid = b['propertyId']?.toString() ?? '';
                  final property = _hostProperties[pid];
                  final title = property?.title ?? 'Property';
                  final imageUrl = property?.images.isNotEmpty == true ? property!.images.first : '';
                  final status = b['status']?.toString() ?? 'pending';
                  final statusColor = (status == 'accepted' || status == 'confirmed') ? Colors.green : Colors.orange;

                  // Parse dates
                  final moveInStr = b['moveInDate']?.toString() ?? '';
                  final moveOutStr = b['moveOutDate']?.toString() ?? '';
                  String dateRange = '';
                  try {
                    final s = DateTime.parse(moveInStr);
                    final e = DateTime.parse(moveOutStr);
                    final nights = e.difference(s).inDays;
                    dateRange = '${DateFormat('dd MMM').format(s)} · $nights night${nights == 1 ? '' : 's'}';
                  } catch (_) {}

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: c.card, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), color: c.statsBg,
                              image: imageUrl.isNotEmpty
                                  ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: imageUrl.isEmpty
                                ? Icon(Icons.home, color: c.textSecondary, size: 28) : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15, fontWeight: FontWeight.w600, color: c.textMain),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                if (dateRange.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(dateRange,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
                                ],
                                const SizedBox(height: 2),
                                Text('${CurrencyFormatter.symbol}${(b['totalPrice'] as num?)?.toStringAsFixed(0) ?? '—'} total',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13, fontWeight: FontWeight.w600, color: c.primary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(width: 10, height: 10,
                                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                              const SizedBox(height: 4),
                              Text(status.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10, fontWeight: FontWeight.bold,
                                      color: statusColor, letterSpacing: 0.8)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  // ─── Recent Messages ──────────────────────────────────────────────────────
  Widget _buildRecentMessages(AppColorScheme c) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('chats').onValue,
      builder: (context, snap) {
        final List<Map<String, dynamic>> chats = [];
        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((chatId, val) {
            final chat = Map<String, dynamic>.from(val as Map);
            if (chat['hostId'] == _uid || chat['guestId'] == _uid) {
              chats.add({'_chatId': chatId, ...chat});
            }
          });
          chats.sort((a, b) {
            final ta = (a['lastMessageTime'] as num?)?.toInt() ?? 0;
            final tb = (b['lastMessageTime'] as num?)?.toInt() ?? 0;
            return tb.compareTo(ta);
          });
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.recentMessages,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 20, fontWeight: FontWeight.bold, color: c.textMain)),
              const SizedBox(height: 12),
              if (chats.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: c.card, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                        decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(Icons.chat_bubble, color: c.primary, size: 20)),
                    const SizedBox(width: 12),
                    Text('No messages yet',
                        style: GoogleFonts.plusJakartaSans(color: c.textSecondary)),
                  ]),
                )
              else
                ...chats.take(3).map((chat) {
                  final lastMsg = chat['lastMessage'] as String? ?? '—';
                  final isHost = chat['hostId'] == _uid;
                  final otherUid = isHost ? chat['guestId'] : chat['hostId'];
                  final ts = (chat['lastMessageTime'] as num?)?.toInt() ?? 0;
                  final timeStr = ts > 0
                      ? DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(ts))
                      : '';

                  return StreamBuilder<DatabaseEvent>(
                    stream: FirebaseDatabase.instance.ref('users/$otherUid').onValue,
                    builder: (context, userSnap) {
                      String otherName = isHost
                          ? (chat['guestName'] as String? ?? 'Guest')
                          : (chat['hostName'] as String? ?? 'Host');
                      String otherImage = '';

                      if (userSnap.hasData && userSnap.data!.snapshot.exists) {
                        final userData = Map<String, dynamic>.from(userSnap.data!.snapshot.value as Map);
                        final fullName = userData['fullName'] as String? ?? '';
                        if (fullName.isNotEmpty) {
                          otherName = fullName.split(' ').first;
                        }
                        otherImage = userData['profileImage'] as String? ?? '';
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: c.card, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.border),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(width: 42, height: 42,
                                decoration: BoxDecoration(
                                  color: c.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  image: otherImage.isNotEmpty
                                      ? DecorationImage(image: NetworkImage(otherImage), fit: BoxFit.cover)
                                      : null,
                                ),
                                child: otherImage.isEmpty
                                    ? Center(child: Text(
                                        otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.primary),
                                      ))
                                    : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(otherName,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14, fontWeight: FontWeight.w600, color: c.textMain)),
                                const SizedBox(height: 3),
                                Text(lastMsg,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: c.textSecondary),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            )),
                            if (timeStr.isNotEmpty)
                              Text(timeStr, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: c.textSecondary)),
                          ],
                        ),
                      );
                    }
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

// ─── Notifications Sheet ──────────────────────────────────────────────────────
class _NotificationsSheet extends StatelessWidget {
  final Map<String, PropertyModel> hostProperties;
  final String uid;
  final AppColorScheme c;
  const _NotificationsSheet({required this.hostProperties, required this.uid, required this.c});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').onValue,
      builder: (context, snap) {
        final List<Map<String, dynamic>> items = [];
        if (snap.hasData && snap.data!.snapshot.exists) {
          final raw = snap.data!.snapshot.value as Map;
          raw.forEach((key, val) {
            final b = Map<String, dynamic>.from(val as Map);
            final pid = b['propertyId']?.toString() ?? '';
            if (hostProperties.containsKey(pid) && b['guestId']?.toString() != uid) {
              items.add({'_key': key, ...b});
            }
          });
          items.sort((a, b) {
            final ta = (a['createdAt'] as num?)?.toInt() ?? 0;
            final tb = (b['createdAt'] as num?)?.toInt() ?? 0;
            return tb.compareTo(ta);
          });
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Text(AppStrings.notifications,
                    style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('No notifications', style: GoogleFonts.plusJakartaSans(color: c.textSecondary)),
                  )
                else
                  ...items.take(5).map((b) {
                    final pid = b['propertyId']?.toString() ?? '';
                    final propTitle = hostProperties[pid]?.title ?? 'Property';
                    final status = b['status']?.toString() ?? 'pending';
                    final title = status == 'pending' ? 'New booking request' : 'Booking ${status}';
                    final ts = (b['createdAt'] as num?)?.toInt() ?? 0;
                    final timeStr = ts > 0
                        ? DateFormat('dd MMM, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(ts))
                        : '';
                    return ListTile(
                      leading: Container(width: 40, height: 40,
                          decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Icon(Icons.notifications, color: c.primary, size: 20)),
                      title: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: c.textMain)),
                      subtitle: Text('$propTitle\n$timeStr',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
                    );
                  }),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.close,
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textSecondary)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
