import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<Dashbord> {
  final List<Map<String, dynamic>> _activeReservations = [
    {
      'id': '1',
      'title': 'Victory Square Modern Studio',
      'description': 'Guest: Radu Enescu • 4 nights',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAmpBCVXHgvMMYqtOgFcm7vXIc36iqhQ-Xy2dy46w1hGRf6tSjwsjZGe4uTCnPRYN1lFB6rlosa1IpLwpAlJ7SYZDyYgbR_YDFFAO6zQKM40anTyYoS8YlP9etKxibg-cEQaY9UJRy7LqVoNxd__Rq08KcXxDSclkaLkCQm9mWFzbRm-bY8_tIOOoMU2ik5M33558ehNGHj-iGgolIBRg1JgMl4_Jws6sVLZctLMIvHgtXmK4dt-2kVj9PtbSkllJJBxzAy8-cCH2Q',
      'status': 'active',
      'statusColor': Colors.green,
    },
    {
      'id': '2',
      'title': 'Cluj-Napoca Central Loft',
      'description': 'Guest: Elena M. • 14 nights',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCGXa2i5FTOKjpJM5ovOFz1-d0v1GzLXiZRnZXSosvJnUjrKiq3n8Y6WD6rwwfgIZDdeBQBSsBGN8M9xHbdH_M7q_u2Yio6UC526B9yxXYmiqbUYa1zGi2OSnCMFALWyctPhkGAkLJr8C7Gwv2SRUQN5Qfyfu7v3FIXlb5emS_o-a4tmjBhK9wyeVRxEJ_ZxvZSZZfgOWhMEG_2SCHSwjjCQXBo0idodZCLuTQJ4VFMBRDhkKeo_7F7TVuj1dVyl2a2b3Mvw5NvIDg',
      'status': 'active',
      'statusColor': Colors.green,
    },
    {
      'id': '3',
      'title': 'Old Town Brașov House',
      'description': 'Guest: Thomas K. • 2 nights',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBOYzN4jniR9mHKQAz2lC1bOrPtOkuqQOOs541zmVbz3pXBFEVpFuhb_WPA39G0E4DaZGxTk6y0b7pi-nTQYfosQOmlmOyth6HPrj3-snXfpYan1Y7Cqwcqv6SAfl1ryUWSBNfF-w_wsDlArKYf4-9Vjw9uHJhkq2wUfnFlpvuepYxto6aE5Oxkwmx1OPxJgqa-A7YWVhA_ogefJ66Qb9wIeW1Z0Sxus0qFYW8EnIb2uw9HNDtpE2MoBmPUfPY8R2FXXQizMJGfwAM',
      'status': 'arriving',
      'statusColor': Colors.orange,
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
            // Top App Bar
            _buildTopAppBar(c),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    // Performance Overview Section
                    _buildPerformanceOverview(c),

                    // Quick Actions
                    _buildQuickActions(c),

                    // Active Reservations Section
                    _buildActiveReservations(c),

                    // Recent Messages Preview
                    _buildRecentMessages(c),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top App Bar
  Widget _buildTopAppBar(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: c.card,
        border: Border(bottom: BorderSide(color: c.border, width: 1)),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBsF3RTcJ8nwYGCM_3o7Roe8yervPoe984BO1yCTUJzNzZJyTeI75skV9Q0qYSbvdnmV6yAekvcTvw3yxMo7R2t5v_18gNaLW8ewMLrrOGQlLZnPBSsxuYfVhPDvOqdbWBxWZWEf0CzKTLbarDh8sPXGZVDky8iYNY6sZkU5UknJrZ9tgY3iGGiJ_KmsTE66id8jOcoy6vtnIGERTZPHbIkHGlUjB7n-f4VHy2OkvSlItpHlc8bZaRQfyjQVYP887-pIVgWCymyqO8',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: Text(
                'Host Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                  height: 1.2,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),

          // Notification Button with Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: c.card,
            ),
            child: Stack(
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      // Show notifications
                      _showNotifications(c);
                    },
                    icon: const Icon(Icons.notifications, size: 24),
                    padding: EdgeInsets.zero,
                    color: c.textMain,
                  ),
                ),
                // Notification Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: c.card, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Performance Overview Section
  Widget _buildPerformanceOverview(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Performance Overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
              letterSpacing: -0.015,
            ),
          ),

          const SizedBox(height: 12),

          // Stats Cards
          Row(
            children: [
              // Monthly Earnings Card
              Expanded(
                child: _buildStatCard(
                  title: 'Monthly Earnings',
                  value: '€4,820',
                  trend: '+12.4%',
                  isPositive: true,
                  c: c,
                ),
              ),

              const SizedBox(width: 16),

              // Occupancy Rate Card
              Expanded(
                child: _buildStatCard(
                  title: 'Occupancy Rate',
                  value: '94%',
                  trend: '+3.1%',
                  isPositive: true,
                  c: c,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stat Card Widget
  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required AppColorScheme c,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Trend
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quick Actions
  Widget _buildQuickActions(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        children: [
          // Action Buttons Grid
          Row(
            children: [
              // New Listing Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Create new listing
                    _createNewListing(c);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_box, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'New Listing',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Sync Calendar Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Sync calendar
                    _syncCalendar(c);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary.withValues(alpha: 0.1),
                    foregroundColor: c.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sync, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Sync Calendar',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Active Reservations Section
  Widget _buildActiveReservations(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Reservations',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                  height: 1.2,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all reservations
                  _viewAllReservations(c);
                },
                child: Text(
                  'View all',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Reservations List
          Column(
            children: [
              for (var reservation in _activeReservations)
                _buildReservationItem(reservation, c),
            ],
          ),
        ],
      ),
    );
  }

  // Reservation Item Widget
  Widget _buildReservationItem(
    Map<String, dynamic> reservation,
    AppColorScheme c,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // View reservation details
            _viewReservationDetails(reservation);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Property Image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(reservation['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Property Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation['title'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: c.textMain,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reservation['description'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: c.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Status Indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: reservation['statusColor'],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reservation['status'].toString().toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: reservation['statusColor'],
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Recent Messages Section
  Widget _buildRecentMessages(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Recent Messages',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // Message Preview Card
          Container(
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chat_bubble,
                      color: c.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Message Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sender Name
                        Text(
                          'Andrei Ionescu',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.textMain,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Message Preview
                        Text(
                          '"Buna ziua! Is the check-in flexible for tomorrow evening?"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: c.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Time Stamp
                        Text(
                          '20 mins ago',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show Notifications
  void _showNotifications(AppColorScheme c) {
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
                  'Notifications',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
                const SizedBox(height: 20),
                _buildNotificationItem(
                  title: 'New booking request',
                  description: 'Cluj-Napoca Central Loft',
                  time: '2 hours ago',
                  c: c,
                ),
                _buildNotificationItem(
                  title: 'Payment received',
                  description: '€450 for Victory Square Studio',
                  time: '5 hours ago',
                  c: c,
                ),
                _buildNotificationItem(
                  title: 'Guest review',
                  description: 'Maria gave 5 stars to Old Town House',
                  time: '1 day ago',
                  c: c,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
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

  // Notification Item
  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String time,
    required AppColorScheme c,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.notifications, color: c.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.textMain,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Create New Listing
  void _createNewListing(AppColorScheme c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Creating new listing...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Sync Calendar
  void _syncCalendar(AppColorScheme c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Syncing calendar...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // View All Reservations
  void _viewAllReservations(AppColorScheme c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Viewing all reservations...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // View Reservation Details
  void _viewReservationDetails(Map<String, dynamic> reservation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${reservation['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

}
