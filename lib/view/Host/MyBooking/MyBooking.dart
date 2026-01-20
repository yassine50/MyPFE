import 'package:flutter/material.dart';
import 'package:pfe/view/Host/InvitationDetails/InvitationDetails.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBooking> {
  int _selectedTab = 0;
  
  final List<String> _tabs = ['Requests (2)', 'Upcoming', 'History'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF101822) : const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1A222C) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF111418),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 24),
            color: isDarkMode ? Colors.white : const Color(0xFF111418),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Buttons
          Container(
            color: isDarkMode ? const Color(0xFF1A222C) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2A3441) : const Color(0xFFF0F2F4),
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
                              ? (isDarkMode ? const Color(0xFF3B4758) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
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
                                  ? (isDarkMode ? Colors.white : const Color(0xFF111418))
                                  : (isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF617289)),
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Urgent Request Card
                _buildRequestCard(
                  isDarkMode: isDarkMode,
                  expireIcon: Icons.timer,
                  expireText: 'Expires in 12h',
                  expireColor: const Color(0xFFEA580C),
                  badgeText: 'NEW',
                  badgeColor: const Color(0xFFDBEAFE),
                  badgeTextColor: const Color(0xFF136DEC),
                  title: 'Cozy Studio in Cluj',
                  details: '3 nights • Oct 12 - Oct 15',
                  renterImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCi-rAu4s-PEK7B_VYpn6ZXhYC7sggA-FHEQoprl917XZaOqvlqBBJF6EVZzg6gzv6_-IQnvQ6oIRGiEXyaDDmjKutrJm4kmq4CxH8bvGcXkOP8I9Bn1lyLvkduYIeOiEED9hb3ndPfjK-298jDbksKyGwx_7R9MIzNaSruEAxuP5ZSkTAyp1OsP6yJsCB7knDAXHg1rMWHS3S5eaK4IIbcy-Du11tzngvAjCYh02Bdkwjv27IEdTsSKwyen3BF-TRpnNswot3pd0E',
                  renterName: 'Andrei Popescu',
                  renterRating: '4.9 ★',
                  price: '€185',
                  priceUnit: 'total',
                  propertyImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD6xAP1anvHaBQ_PfwOmSrkkfRD7Wfk65JZ0EM93FQ4anRu1M1G8vNOrHXt20_kY_xpf3PCHzJuQpsB3-fkUIT-OEWAk0-H6bhscv1z4YRcehXPIZrlcZYEdKvxUwVzNATTQ0LbzmSfFM5k_IOtW6RG8yovA2WqBzt-Z6FTmPhPwDKm5RRoTxNJBRsfkV4a1VerM3iCJbWCZlSFgzzIF1_rgIDp9LmS1T2XqZlxBoEUBlTUbEqydWER6yixRXTzgdd3fbSEHTFK3Os',
                ),
                const SizedBox(height: 16),
                // Very Urgent Request Card
                _buildRequestCard(
                  isDarkMode: isDarkMode,
                  expireIcon: Icons.error,
                  expireText: 'Expires in 45m',
                  expireColor: const Color(0xFFDC2626),
                  badgeText: 'LONG TERM',
                  badgeColor: const Color(0xFFF3E8FF),
                  badgeTextColor: const Color(0xFF9333EA),
                  title: 'Modern Loft in Bucharest',
                  details: '29 nights • Nov 1 - Nov 30',
                  renterImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDbRglnLBV9mYFg5J02Wu7mCuHD4djpyEY4YPSr5Qq_dhgHWgW6ba70S6Xk5ySGqVURLORko2cRdF1M_m38-4qBsqGjLzDwRwRrOJT7-uALJVRWmGQ67SaDxVKXKCZwXE2YlK_Ai1sFzTO4Euugs_LggMjvI5ktL7kNZ437RmMXMRyIOH8Xh9o6ZQ1FQg3Y4YcVmeVWSuBYjhuITJeKw96eiAhDXejzF4zsRdiae92a9nNLDNy6QJAt--u84Xy4OLbZwd5VI5-o3Ho',
                  renterName: 'Maria Ionescu',
                  renterRating: 'New',
                  price: '€1,200',
                  priceUnit: '/ month',
                  propertyImage: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDHEmy8TSMq5m_4l_5s1HDi8H8t0plQ3FkTsG7BjC0zpY1jl-RDqd8Ve_HLAkxhif3-MrBW-8-MMugBjuhV3hQGbMdfyxxxAxEC6sruCQnpbbiKopHRATfaqDgvt9dwqEieQXoW4aJuAtauI7dU9bZJLKyxHT4mVm-zkTcaLxYM5F932t7FdhASrkB8Kvg53ZWzico6k5YEi6Zn7J_XjLo1kcJiIt5cNzVJOMTyOQ14n4f5r2YTXfoOfiWI74fNkhH3pxbSGaOPYn4',
                  isUrgent: true,
                ),
                const SizedBox(height: 24),
                // Upcoming Teaser
                Opacity(
                  opacity: 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF111418),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1A222C) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirmed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF617289),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Sunny 2BR Apartment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : const Color(0xFF111418),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dec 15 - Dec 20',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF617289),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCxDhwwCvMvAv4UQhZtNQIANSTxdOL4ysBMoLlB4_5UZPm3E62kb9c7qHvbaWmqWGt38Aywt0okJqyL2xw62jlX-KDRq9J89_QN3nlgIn8S8O-Yu1yUsjlaUgjzn0ObFDz9f_Ab1MnPioCj-R92ON0fvJRXzjLP3OayvGxPoqDeCIeDNUAa6EBHY-SLSryZFucfVP_dy-rDb31DWbdU0MORAOCdREXs0Rri6FbnXavvuXNwsnYWZZzgwr2yb2cr3YcXMQ0IyI9F5zs',
                                  ),
                                  fit: BoxFit.cover,
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required bool isDarkMode,
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
          color: isDarkMode ? const Color(0xFF1A222C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF2A3441) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                    Icon(
                      expireIcon,
                      color: expireColor,
                      size: 16,
                    ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
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
                              color: isDarkMode ? Colors.white : const Color(0xFF111418),
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
                            color: isDarkMode ? Colors.white : const Color(0xFF111418),
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
              color: isDarkMode ? const Color(0xFF2A3441) : const Color(0xFFF3F4F6),
            ),
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
                      side: BorderSide(
                        color: isDarkMode ? const Color(0xFF3B4758) : const Color(0xFFDCE0E5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF111418),
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF136DEC),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                    child: const Text(
                      'Accept',
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
          ],
        ),
      ),
    );
  }
}