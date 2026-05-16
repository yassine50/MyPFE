import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:pfe/core/theme/app_colors.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/features/host/presentation/host/invitation_details/invitation_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:intl/intl.dart';
class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBooking> {
  int _selectedTab = 0;

  final List<String> _tabs = [AppStrings.requests, AppStrings.upcoming, AppStrings.history];
  final _database = FirebaseDatabase.instance;
  Map<String, PropertyModel> _properties = {};
  bool _isLoadingProperties = true;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final properties = await PropertyRepository().fetchProperties();
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      for (var p in properties) {
        if (p.hostId == currentUserId) {
          _properties[p.id] = p;
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch properties: $e');
    }
    if (mounted) {
      setState(() {
        _isLoadingProperties = false;
      });
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    try {
      await _database.ref('bookings').child(bookingId).update({'status': status});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking $status successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.myBookings,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: c.textMain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 24),
            color: c.textMain,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Buttons
          Container(
            color: c.card,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: c.inputBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = index == _selectedTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? c.card
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? c.textMain
                                  : c.textSecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Requests List
          Expanded(
            child: _isLoadingProperties
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<DatabaseEvent>(
                    stream: _database.ref('bookings').onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                        return Center(
                          child: Text(
                            'No bookings found.',
                            style: TextStyle(color: c.textSecondary, fontSize: 16),
                          ),
                        );
                      }

                      final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                      final bookings = data.entries.map((e) {
                        final val = e.value as Map<dynamic, dynamic>;
                        return {
                          'id': e.key.toString(),
                          ...val,
                        };
                      }).toList();

                      // Filter based on tab and property ownership
                      // 0 = requests (pending), 1 = upcoming (accepted), 2 = history (rejected/completed)
                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                      final filteredBookings = bookings.where((b) {
                        final propertyId = b['propertyId']?.toString() ?? '';
                        // Must be a property the host owns
                        if (!_properties.containsKey(propertyId)) return false;
                        
                        // Prevent host from seeing their own test requests to themselves as incoming?
                        // Or maybe they just meant they shouldn't see requests for properties they don't own.
                        // Let's hide requests sent by the host themselves, to be safe.
                        if (b['guestId']?.toString() == currentUserId) return false;

                        final status = b['status']?.toString() ?? 'pending';
                        if (_selectedTab == 0) return status == 'pending';
                        if (_selectedTab == 1) return status == 'accepted';
                        if (_selectedTab == 2) return status == 'rejected' || status == 'completed';
                        return false;
                      }).toList();
                      
                      // Sort by createdAt descending
                      filteredBookings.sort((a, b) {
                        final aTime = (a['createdAt'] ?? 0) as int;
                        final bTime = (b['createdAt'] ?? 0) as int;
                        return bTime.compareTo(aTime);
                      });

                      if (filteredBookings.isEmpty) {
                        return Center(
                          child: Text(
                            'No items in this category.',
                            style: TextStyle(color: c.textSecondary, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          final propertyId = booking['propertyId']?.toString() ?? '';
                          final property = _properties[propertyId];
                          
                          final moveInStr = booking['moveInDate']?.toString() ?? '';
                          final moveOutStr = booking['moveOutDate']?.toString() ?? '';
                          
                          DateTime? moveIn;
                          DateTime? moveOut;
                          try { moveIn = DateTime.parse(moveInStr); } catch (_) {}
                          try { moveOut = DateTime.parse(moveOutStr); } catch (_) {}
                          
                          final nights = moveIn != null && moveOut != null 
                              ? moveOut.difference(moveIn).inDays 
                              : 0;
                              
                          final dateRange = moveIn != null && moveOut != null
                              ? '${DateFormat('MMM d').format(moveIn)} - ${DateFormat('MMM d').format(moveOut)}'
                              : 'Unknown dates';

                          final title = property?.title ?? 'Unknown Property';
                          final propertyImage = property?.images.isNotEmpty == true
                              ? property!.images.first
                              : 'https://placehold.co/400x400/png';
                              
                          final totalPrice = booking['totalPrice']?.toString() ?? '0';

                          return _buildRequestCard(
                            bookingId: booking['id'] as String,
                            status: booking['status']?.toString() ?? 'pending',
                            c: c,
                            expireIcon: Icons.timer,
                            expireText: AppStrings.expires12h,
                            expireColor: const Color(0xFFEA580C),
                            badgeText: AppStrings.newBadge,
                            badgeColor: const Color(0xFFDBEAFE),
                            badgeTextColor: const Color(0xFF136DEC),
                            title: title,
                            details: '$nights nights • $dateRange',
                            renterImage: 'https://i.pravatar.cc/150?u=${booking['guestId']}',
                            renterName: 'Guest User', // We don't have user profiles fetched yet
                            renterRating: 'New',
                            price: '€$totalPrice',
                            priceUnit: 'total',
                            propertyImage: propertyImage,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String bookingId,
    required String status,
    required AppColorScheme c,
    required IconData expireIcon,
    required String expireText,
    required Color expireColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String details,
    required String renterImage,
    required String renterName,
    required String renterRating,
    required String price,
    required String priceUnit,
    required String propertyImage,
    bool isUrgent = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const InvitationDetails(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: c.statsBg,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Timer and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(expireIcon, color: expireColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      expireText,
                      style: TextStyle(
                        fontSize: 12,
                        color: expireColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 12,
                      color: badgeTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Content Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c.textMain,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF617289),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Renter Profile
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(renterImage),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            renterName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: c.textMain,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• $renterRating',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF617289),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: c.textMain,
                          ),
                          children: [
                            TextSpan(
                              text: ' $priceUnit',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF617289),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Property Thumbnail
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(propertyImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Container(
              height: 1,
              color: c.border,
            ),
            const SizedBox(height: 12),
            // Action Buttons
            if (status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateBookingStatus(bookingId, 'rejected'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: c.border,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppStrings.decline,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: c.textMain,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateBookingStatus(bookingId, 'accepted'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF136DEC),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                      ),
                      child: Text(
                        AppStrings.accept,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (status != 'pending')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: status == 'accepted' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: status == 'accepted' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
