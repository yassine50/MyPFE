import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:intl/intl.dart';
import 'package:pfe/features/booking/presentation/active_contract/active_contract_screen.dart';
import 'package:pfe/features/booking/presentation/payment/payment_screen.dart';


class MyBookingRenter extends StatefulWidget {
  const MyBookingRenter({super.key});

  @override
  State<MyBookingRenter> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingRenter> {
  int _selectedSegmentIndex = 0;
  final _database = FirebaseDatabase.instance;
  final Map<String, PropertyModel> _properties = {};
  bool _isLoadingProperties = true;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final properties = await PropertyRepository().fetchProperties();
      for (var p in properties) {
        _properties[p.id] = p;
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

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(c),

            // Segmented Buttons
            _buildSegmentedButtons(c),

            // Bookings List
            Expanded(
              child: _isLoadingProperties
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<DatabaseEvent>(
                      stream: _database.ref('bookings').orderByChild('guestId').equalTo(FirebaseAuth.instance.currentUser?.uid).onValue,
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
                        final List<Map<String, dynamic>> fetchedBookings = data.entries.map((e) {
                          final val = e.value as Map<dynamic, dynamic>;
                          final map = <String, dynamic>{
                            'id': e.key.toString(),
                          };
                          val.forEach((k, v) {
                            map[k.toString()] = v;
                          });
                          return map;
                        }).toList();

                        // Filter based on segment index
                        // 0 = upcoming (pending/accepted), 1 = past (completed), 2 = cancelled (rejected/cancelled)
                        final filteredBookings = fetchedBookings.where((b) {
                          final status = b['status']?.toString() ?? 'pending';
                          if (_selectedSegmentIndex == 0) return status == 'pending' || status == 'accepted' || status == 'confirmed' || status == 'active';
                          if (_selectedSegmentIndex == 1) return status == 'completed';
                          if (_selectedSegmentIndex == 2) return status == 'rejected' || status == 'cancelled';
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

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            children: filteredBookings.map((b) {
                              final propertyId = b['propertyId']?.toString() ?? '';
                              final property = _properties[propertyId];
                              
                              final moveInStr = b['moveInDate']?.toString() ?? '';
                              final moveOutStr = b['moveOutDate']?.toString() ?? '';
                              
                              DateTime? moveIn;
                              DateTime? moveOut;
                              try { moveIn = DateTime.parse(moveInStr); } catch (_) {}
                              try { moveOut = DateTime.parse(moveOutStr); } catch (_) {}
                              
                              final dateRange = moveIn != null && moveOut != null
                                  ? '${DateFormat('MMM d').format(moveIn)} - ${DateFormat('MMM d').format(moveOut)}'
                                  : 'Unknown dates';

                              final title = property?.title ?? 'Unknown Property';
                              final location = property?.subtitle ?? 'Unknown Location';
                              final image = property?.images.isNotEmpty == true
                                  ? property!.images.first
                                  : 'https://placehold.co/400x400/png';

                              final status = b['status']?.toString() ?? 'pending';
                              String statusText = status.toUpperCase();
                              Color statusColor = Colors.grey;
                              IconData statusIcon = Icons.info;
                              String primaryAction = 'details';
                              String primaryText = AppStrings.btnViewDetails;

                              if (status == 'pending') {
                                statusColor = Colors.amber;
                                statusIcon = Icons.hourglass_top;
                                statusText = 'PENDING';
                              } else if (status == 'accepted') {
                                statusColor = Colors.orange;
                                statusIcon = Icons.payment;
                                statusText = 'ACTION REQUIRED: PAY';
                                primaryAction = 'pay';
                                primaryText = '💳 Pay Now';
                              } else if (status == 'confirmed' || status == 'active') {
                                statusColor = Colors.green;
                                statusIcon = Icons.check_circle;
                                statusText = 'CONFIRMED';
                                primaryAction = 'contract';
                                primaryText = '📄 View Contract';
                              } else if (status == 'rejected' || status == 'cancelled') {
                                statusColor = Colors.red;
                                statusIcon = Icons.cancel;
                              } else if (status == 'completed') {
                                statusColor = Colors.blue;
                                statusIcon = Icons.bookmark;
                              }

                              final uiBooking = {
                                'id': b['id'],
                                'title': title,
                                'location': location,
                                'dates': dateRange,
                                'status': status,
                                'statusText': statusText,
                                'statusColor': statusColor,
                                'statusIcon': statusIcon,
                                'image': image,
                                'primaryButtonText': primaryText,
                                'primaryButtonAction': primaryAction,
                                'secondaryButtonIcon': Icons.map,
                                'secondaryButtonAction': 'map',
                                'property': property,
                                'rawBooking': b,
                              };
                              return _buildBookingCard(uiBooking, c);
                            }).toList(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.9),
        border: Border(bottom: BorderSide(color: c.border, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                AppStrings.myBookings,
                style: GoogleFonts.publicSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                  letterSpacing: -0.5,
                ),
              ),

              // History Button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: c.card,
                ),
                child: IconButton(
                  onPressed: () {
                    // Show booking history
                    _showBookingHistory(c);
                  },
                  icon: const Icon(Icons.history, size: 24),
                  padding: EdgeInsets.zero,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Segmented Buttons
  Widget _buildSegmentedButtons(AppColorScheme c) {
    final List<String> segments = [AppStrings.upcoming, AppStrings.past, AppStrings.cancelled];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: c.segmentBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            for (int i = 0; i < segments.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSegmentIndex = i;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedSegmentIndex == i
                          ? c.card
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _selectedSegmentIndex == i
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        segments[i],
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          fontWeight: _selectedSegmentIndex == i
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _selectedSegmentIndex == i
                              ? c.textMain
                              : c.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Booking Card
  Widget _buildBookingCard(
    Map<String, dynamic> booking,
    AppColorScheme c,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section
          SizedBox(
            height: 160,
            child: Stack(
              children: [
                // Background Image
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(booking['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Status Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.card.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          booking['statusIcon'],
                          color: booking['statusColor'],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking['statusText'],
                          style: GoogleFonts.publicSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: booking['statusColor'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // More Options Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c.card.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showBookingOptions(booking, c);
                      },
                      icon: const Icon(Icons.more_horiz, size: 20),
                      padding: EdgeInsets.zero,
                      color: c.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['title'],
                            style: GoogleFonts.publicSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking['location'],
                            style: GoogleFonts.publicSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Dates
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: c.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      booking['dates'],
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    // Primary Button
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            _handlePrimaryButtonAction(booking);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                booking['primaryButtonAction'] == 'message'
                                ? c.primary
                                : c.buttonBg,
                            foregroundColor:
                                booking['primaryButtonAction'] == 'message'
                                ? Colors.white
                                : c.textMain,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            booking['primaryButtonText'],
                            style: GoogleFonts.publicSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Secondary Button (if exists)
                    if (booking['secondaryButtonIcon'] != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: c.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _handleSecondaryButtonAction(booking);
                          },
                          icon: Icon(booking['secondaryButtonIcon'], size: 20),
                          padding: EdgeInsets.zero,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show Booking History
  void _showBookingHistory(AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.bookingHistory,
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHistoryItem(
                  title: AppStrings.completedBookings,
                  c: c,
                  onTap: () {
                    setState(() {
                      _selectedSegmentIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildHistoryItem(
                  title: AppStrings.cancelledBookings,
                  c: c,
                  onTap: () {
                    setState(() {
                      _selectedSegmentIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildHistoryItem(
                  title: AppStrings.allBookings,
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.close,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // History Item
  Widget _buildHistoryItem({
    required String title,
    required AppColorScheme c,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.publicSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textMain,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: c.textSecondary),
      onTap: onTap,
    );
  }

  // Show Booking Options
  void _showBookingOptions(
    Map<String, dynamic> booking,
    AppColorScheme c,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  booking['title'],
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildOptionItem(
                  icon: Icons.edit,
                  label: AppStrings.modifyBooking,
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to modify booking page
                  },
                ),
                _buildOptionItem(
                  icon: Icons.cancel,
                  label: AppStrings.cancelBooking,
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    _cancelBooking(booking);
                  },
                ),
                _buildOptionItem(
                  icon: Icons.receipt,
                  label: AppStrings.viewReceipt,
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    // Show receipt
                  },
                ),
                _buildOptionItem(
                  icon: Icons.share,
                  label: AppStrings.shareDetails,
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    _shareBookingDetails(booking);
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // Option Item
  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required AppColorScheme c,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: c.textMain),
      title: Text(
        label,
        style: GoogleFonts.publicSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textMain,
        ),
      ),
      onTap: onTap,
    );
  }

  // Handle Primary Button Action
  void _handlePrimaryButtonAction(Map<String, dynamic> booking) {
    final action = booking['primaryButtonAction'];

    switch (action) {
      case 'message':
        _messageHost(booking);
        break;
      case 'pay':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(
              booking: Map<String, dynamic>.from(booking['rawBooking'] as Map),
            ),
          ),
        );
        break;
      case 'contract':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActiveContractScreen(
              booking: Map<String, dynamic>.from(booking['rawBooking'] as Map),
              property: booking['property'] as PropertyModel?,
            ),
          ),
        );
        break;
      case 'details':
        _viewBookingDetails(booking);
        break;
      case 'complete':
        _completeBooking(booking);
        break;
    }
  }

  // Handle Secondary Button Action
  void _handleSecondaryButtonAction(Map<String, dynamic> booking) {
    final action = booking['secondaryButtonAction'];

    switch (action) {
      case 'map':
        _viewLocation(booking);
        break;
      case 'call':
        _callHost(booking);
        break;
    }
  }

  // Message Host
  void _messageHost(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaging host for ${booking['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // View Booking Details
  void _viewBookingDetails(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${booking['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Complete Booking
  void _completeBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Completing booking for ${booking['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // View Location
  void _viewLocation(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening map for ${booking['location']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Call Host
  void _callHost(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling host for ${booking['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Cancel Booking
  void _cancelBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        final c = context.appColors;

        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.cancelBooking,
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textMain,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel your booking for ${booking['title']}?',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              color: c.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.keepBooking,
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  // Remove booking from list
                  // In real app, you would update the backend
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking for ${booking['title']} cancelled'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                AppStrings.cancelBooking,
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Share Booking Details
  void _shareBookingDetails(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing details for ${booking['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
