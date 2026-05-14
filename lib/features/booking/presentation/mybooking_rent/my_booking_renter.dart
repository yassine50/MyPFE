import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class MyBookingRenter extends StatefulWidget {
  const MyBookingRenter({super.key});

  @override
  State<MyBookingRenter> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingRenter> {
  int _selectedSegmentIndex = 0;

  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'id': '1',
      'title': 'Downtown Co-living Studio',
      'location': 'Bucharest, Romania',
      'dates': '14 Nov - 20 Nov 2023',
      'status': 'confirmed',
      'statusText': 'Confirmed',
      'statusColor': Colors.green,
      'statusIcon': Icons.check_circle,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBHKqiCSvmCqD-kSqMLCQIWVGMwgXyptLiCRomPOHHSQKPA9VskIb3GZb8-dJYbeer_aSJPEBqglMIfsu-ZgBT0sUUNv0Bx5R0gOrpv25KJB0KpixDQ5gviYWpRyqUkRo5NeiFHhJ5h7OykJWnJzobk74fVWtMkoxxv2wzF_uQDQB89-5YinqmvOxMQJ8ouotc6rQvm3VsSX61-mq8eI-ArcT0cprIEsdqsIxsk_gUttPuQfZTpSbGfbxA_aBjfsAWHBrkPv91iNZY',
      'primaryButtonText': 'Message Host',
      'primaryButtonAction': 'message',
      'secondaryButtonIcon': Icons.map,
      'secondaryButtonAction': 'map',
    },
    {
      'id': '2',
      'title': 'Mountain View Chalet',
      'location': 'Brasov, Romania',
      'dates': '10 Dec - 15 Dec 2023',
      'status': 'checkin_soon',
      'statusText': 'Check-in Soon',
      'statusColor': Colors.amber,
      'statusIcon': Icons.hourglass_top,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDRVuL_msPu6KA2s66LXK6Vo19oY-qk9ziOado1tiK17uaduF464A6WFNKLKjZSuUX-HLLRqW7dhdgZxM8aNXOK5PUk5u8Jt3no1PYielkiqQg7sE8qiODHZ9QFMyN6PUMCC0Ai_-ZP9EYloOqcAw2QyKl48jAJVtH4jBsS7AJM-317mQ83cljC5jDKTN4lvfQiJfZRAgmXUqwg3HaymZ2BuF-oqFB4aJY1oSSs6lawh5BU0loMFBH6DWp2XHiNLUz_zawAt1w00fY',
      'primaryButtonText': 'View Details',
      'primaryButtonAction': 'details',
      'secondaryButtonIcon': Icons.call,
      'secondaryButtonAction': 'call',
    },
    {
      'id': '3',
      'title': 'Modernist Cluj Flat',
      'location': 'Cluj-Napoca, Romania',
      'dates': '05 Jan - 08 Jan 2024',
      'status': 'saved',
      'statusText': 'Saved',
      'statusColor': Colors.blue,
      'statusIcon': Icons.bookmark,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBoFttS8R7hCY_xMc24Iit-TzVEwRoHxrvcX6kmeBoQsMo04qdEEsF4Jl-0_RvmxCMgsydmsBtClsrIPTSUjOB-eUVyGyPMHfDo_yX_9vD4zgSHPACIfI_vssLRQ-8K1avmKK6EfazWfviENRCuNBkuZWAq5SaMyFneMV7A6AyFB_LR7wrDK5lFJy_OjR3ZW57E5TpuEtszrqxZQTIAfMiJQPWy9-bRMeZHLrQ0Sp1V4jWZa5puX0X9rcmxlBoyyONQ4i4yqK5wCNM',
      'primaryButtonText': 'Complete Booking',
      'primaryButtonAction': 'complete',
      'secondaryButtonIcon': null,
      'secondaryButtonAction': null,
    },
  ];

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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    for (var booking in _upcomingBookings)
                      _buildBookingCard(booking, c),
                  ],
                ),
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
                'My Bookings',
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
    final List<String> segments = ['Upcoming', 'Past', 'Cancelled'];

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
                  'Booking History',
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHistoryItem(
                  title: 'Completed (12)',
                  c: c,
                  onTap: () {
                    setState(() {
                      _selectedSegmentIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildHistoryItem(
                  title: 'Cancelled (2)',
                  c: c,
                  onTap: () {
                    setState(() {
                      _selectedSegmentIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                _buildHistoryItem(
                  title: 'All Bookings',
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
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
                  label: 'Modify Booking',
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to modify booking page
                  },
                ),
                _buildOptionItem(
                  icon: Icons.cancel,
                  label: 'Cancel Booking',
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    _cancelBooking(booking);
                  },
                ),
                _buildOptionItem(
                  icon: Icons.receipt,
                  label: 'View Receipt',
                  c: c,
                  onTap: () {
                    Navigator.pop(context);
                    // Show receipt
                  },
                ),
                _buildOptionItem(
                  icon: Icons.share,
                  label: 'Share Details',
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
                    'Cancel',
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
            'Cancel Booking',
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
                'Keep Booking',
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
                'Cancel Booking',
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
