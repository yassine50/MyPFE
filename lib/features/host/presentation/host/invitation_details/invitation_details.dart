import 'package:flutter/material.dart';

import 'package:pfe/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pfe/features/chat/data/repositories/chat_repository.dart';

class InvitationDetails extends StatefulWidget {
  final String bookingId;
  const InvitationDetails({super.key, required this.bookingId});

  @override
  State<InvitationDetails> createState() => _InvitationDetailsState();
}

class _InvitationDetailsState extends State<InvitationDetails> {
  Future<Map<String, dynamic>> _fetchDetails(String guestId, String propertyId) async {
    final userSnap = await FirebaseDatabase.instance.ref('users/$guestId').get();
    final propSnap = await FirebaseDatabase.instance.ref('properties/$propertyId').get();

    Map<String, dynamic> user = {};
    if (userSnap.exists && userSnap.value != null) {
      user = Map<String, dynamic>.from(userSnap.value as Map);
    }

    Map<String, dynamic> prop = {};
    if (propSnap.exists && propSnap.value != null) {
      prop = Map<String, dynamic>.from(propSnap.value as Map);
    }

    return {
      'user': user,
      'property': prop,
    };
  }

  Future<void> _updateBookingStatus(String status, String propertyId, String guestId) async {
    try {
      await FirebaseDatabase.instance.ref('bookings/${widget.bookingId}').update({'status': status});
      
      final hostId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (hostId.isNotEmpty && propertyId.isNotEmpty && guestId.isNotEmpty) {
        final chatRepo = ChatRepository();
        final chatId = await chatRepo.createOrGetChat(propertyId, hostId, guestId);
        
        if (status == 'accepted') {
          await chatRepo.openChat(chatId);
          await chatRepo.sendMessage(chatId, hostId, "I have accepted your booking request. Welcome!");
        } else if (status == 'rejected') {
          await chatRepo.closeChat(chatId);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking $status successfully'),
            backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update booking: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings/${widget.bookingId}').onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return Scaffold(backgroundColor: c.background, body: const Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || !snapshot.data!.snapshot.exists) {
          return Scaffold(
            backgroundColor: c.background,
            appBar: AppBar(title: const Text('Booking Not Found')),
            body: const Center(child: Text('This booking may have been deleted.')),
          );
        }

        final booking = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final guestId = booking['guestId']?.toString() ?? '';
        final propertyId = booking['propertyId']?.toString() ?? '';
        final status = booking['status']?.toString() ?? 'pending';

        return FutureBuilder<Map<String, dynamic>>(
          future: _fetchDetails(guestId, propertyId),
          builder: (context, detailsSnap) {
            final user = detailsSnap.data?['user'] as Map<String, dynamic>? ?? {};
            final property = detailsSnap.data?['property'] as Map<String, dynamic>? ?? {};

            final isLoadingDetails = detailsSnap.connectionState == ConnectionState.waiting;

            return Scaffold(
              backgroundColor: c.background,
              body: SafeArea(
                child: Column(
                  children: [
                    // Top App Bar
                    _buildTopBar(c),

                    if (isLoadingDetails)
                      Expanded(child: Center(child: CircularProgressIndicator(color: c.primary)))
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _buildProfileSection(user, c),
                              _buildPropertySection(property, c),
                              _buildReservationDatesSection(booking, c),
                              _buildGuestMessageSection(booking, user, c),
                              _buildPayoutSummarySection(booking, status, c),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              bottomSheet: (status == 'pending' && !isLoadingDetails) ? _buildFooter(c, propertyId, guestId) : null,
            );
          },
        );
      },
    );
  }

  Widget _buildTopBar(AppColorScheme c) {
    return Container(
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: c.buttonBg),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: c.textMain,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Booking Request',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, letterSpacing: -0.15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> user, AppColorScheme c) {
    final name = user['fullName'] as String? ?? 'Guest User';
    final photoUrl = user['profileImage'] as String? ?? '';
    final createdAtRaw = user['createdAt'];
    String memberSince = '';
    if (createdAtRaw != null) {
      try {
        DateTime d;
        if (createdAtRaw is int) {
          // If it's a timestamp in ms (e.g. from ServerValue.timestamp or Date.now())
          d = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
        } else {
          d = DateTime.parse(createdAtRaw.toString());
        }
        memberSince = 'Member since ${DateFormat('MMM yyyy').format(d)}';
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 128, height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.card, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  color: c.statsBg,
                  image: photoUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: photoUrl.isEmpty ? Icon(Icons.person, size: 56, color: c.textSecondary) : null,
              ),
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: c.primary, shape: BoxShape.circle,
                  border: Border.all(color: c.background, width: 2),
                ),
                child: const Icon(Icons.verified, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(name,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 24, fontWeight: FontWeight.bold, color: c.textMain, letterSpacing: -0.15)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: c.star, size: 16),
              const SizedBox(width: 4),
              Text('New • Verified Member',
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: c.textSecondary)),
            ],
          ),
          if (memberSince.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(memberSince, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary)),
          ]
        ],
      ),
    );
  }

  Widget _buildPropertySection(Map<String, dynamic> property, AppColorScheme c) {
    final title = property['title'] as String? ?? 'Property';
    final location = property['location'] as String? ?? 'Location unavailable';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text('PROPERTY',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.bold, color: c.textSecondary, letterSpacing: 0.5)),
          ),
          Container(
            decoration: BoxDecoration(color: c.statsBg, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.apartment, color: c.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: c.textMain)),
                      const SizedBox(height: 4),
                      Text(location, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
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

  Widget _buildReservationDatesSection(Map<String, dynamic> booking, AppColorScheme c) {
    final moveInStr = booking['moveInDate']?.toString() ?? '';
    final moveOutStr = booking['moveOutDate']?.toString() ?? '';

    DateTime? moveIn;
    DateTime? moveOut;
    try { moveIn = DateTime.parse(moveInStr); } catch (_) {}
    try { moveOut = DateTime.parse(moveOutStr); } catch (_) {}

    final moveInFmt = moveIn != null ? DateFormat('MMM dd, yyyy').format(moveIn) : 'TBD';
    final moveOutFmt = moveOut != null ? DateFormat('MMM dd, yyyy').format(moveOut) : 'TBD';
    final nights = moveIn != null && moveOut != null ? moveOut.difference(moveIn).inDays : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text('RESERVATION DATES',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.bold, color: c.textSecondary, letterSpacing: 0.5)),
          ),
          Row(
            children: [
              _dateCard('CHECK-IN', moveInFmt, c),
              const SizedBox(width: 12),
              _dateCard('CHECK-OUT', moveOutFmt, c),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Icon(Icons.schedule, color: c.primary, size: 16),
                const SizedBox(width: 8),
                Text('$nights Nights Total stay', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCard(String label, String date, AppColorScheme c) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: c.statsBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.border)),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: c.textSecondary)),
            const SizedBox(height: 4),
            Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestMessageSection(Map<String, dynamic> booking, Map<String, dynamic> user, AppColorScheme c) {
    final message = booking['message'] as String? ?? '';
    if (message.isEmpty) return const SizedBox();

    final name = (user['fullName'] as String? ?? 'GUEST').split(' ').first.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 0, 12),
            child: Text('MESSAGE FROM $name',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.bold, color: c.textSecondary, letterSpacing: 0.5)),
          ),
          Container(
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12),
                bottomRight: Radius.circular(12), bottomLeft: Radius.circular(4),
              ),
              border: Border(left: BorderSide(color: c.primary, width: 4)),
            ),
            padding: const EdgeInsets.all(16),
            child: Text('"$message"',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontStyle: FontStyle.italic, color: c.textMain, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutSummarySection(Map<String, dynamic> booking, String status, AppColorScheme c) {
    final totalPrice = (booking['totalPrice'] as num?)?.toDouble() ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.primary, c.primary.withValues(alpha: 0.75)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOUR ESTIMATED PAYOUT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFBFDBFE))),
                    const SizedBox(height: 8),
                    Text(CurrencyFormatter.format(totalPrice),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const Icon(Icons.payments, color: Color(0xFFBFDBFE), size: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (status == 'pending')
            Text('PLEASE RESPOND TO THIS REQUEST',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, fontWeight: FontWeight.bold, color: c.textSecondary, letterSpacing: 1.0))
          else
            Text('STATUS: ${status.toUpperCase()}',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.bold,
                    color: status == 'accepted' ? Colors.green : Colors.red, letterSpacing: 1.0)),
        ],
      ),
    );
  }

  Widget _buildFooter(AppColorScheme c, String propertyId, String guestId) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _updateBookingStatus('rejected', propertyId, guestId);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.buttonBg, foregroundColor: c.textMain, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Decline', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  _updateBookingStatus('accepted', propertyId, guestId);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary, foregroundColor: Colors.white, elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Accept Request', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
