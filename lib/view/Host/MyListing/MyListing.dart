import 'package:flutter/material.dart';

class MyListing extends StatelessWidget {
  const MyListing({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF101822) : const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF101822) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: isDarkMode ? Colors.white : const Color(0xFF9CA3AF),
          onPressed: () {},
        ),
        title: Text(
          'My Listings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF111418),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            color: isDarkMode ? Colors.white : const Color(0xFF111418),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard(
                  count: '12',
                  label: 'Active',
                  isActive: true,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  count: '3',
                  label: 'Drafts',
                  isActive: false,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  count: '1',
                  label: 'Hidden',
                  isActive: false,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),

          // Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All properties (16)',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF136DEC),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          // Listings
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildListingCard(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAmpBCVXHgvMMYqtOgFcm7vXIc36iqhQ-Xy2dy46w1hGRf6tSjwsjZGe4uTCnPRYN1lFB6rlosa1IpLwpAlJ7SYZDyYgbR_YDFFAO6zQKM40anTyYoS8YlP9etKxibg-cEQaY9UJRy7LqVoNxd__Rq08KcXxDSclkaLkCQm9mWFzbRm-bY8_tIOOoMU2ik5M33558ehNGHj-iGgolIBRg1JgMl4_Jws6sVLZctLMIvHgtXmK4dt-2kVj9PtbSkllJJBxzAy8-cCH2Q',
                  title: 'Victory Square Modern Studio',
                  location: 'Bucharest, Sector 1',
                  price: '€850',
                  status: 'Active',
                  isActive: true,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildListingCard(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCGXa2i5FTOKjpJM5ovOFz1-d0v1GzLXiZRnZXSosvJnUjrKiq3n8Y6WD6rwwfgIZDdeBQBSsBGN8M9xHbdH_M7q_u2Yio6UC526B9yxXYmiqbUYa1zGi2OSnCMFALWyctPhkGAkLJr8C7Gwv2SRUQN5Qfyfu7v3FIXlb5emS_o-a4tmjBhK9wyeVRxEJ_ZxvZSZZfgOWhMEG_2SCHSwjjCQXBo0idodZCLuTQJ4VFMBRDhkKeo_7F7TVuj1dVyl2a2b3Mvw5NvIDg',
                  title: 'Cluj-Napoca Central Loft',
                  location: 'Cluj-Napoca, City Center',
                  price: '€1,200',
                  status: 'Active',
                  isActive: true,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildListingCard(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBOYzN4jniR9mHKQAz2lC1bOrPtOkuqQOOs541zmVbz3pXBFEVpFuhb_WPA39G0E4DaZGxTk6y0b7pi-nTQYfosQOmlmOyth6HPrj3-snXfpYan1Y7Cqwcqv6SAfl1ryUWSBNfF-w_wsDlArKYf4-9Vjw9uHJhkq2wUfnFlpvuepYxto6aE5Oxkwmx1OPxJgqa-A7YWVhA_ogefJ66Qb9wIeW1Z0Sxus0qFYW8EnIb2uw9HNDtpE2MoBmPUfPY8R2FXXQizMJGfwAM',
                  title: 'Old Town Brașov House',
                  location: 'Brașov, Historic Center',
                  price: '€950',
                  status: 'Hidden',
                  isActive: false,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String count,
    required String label,
    required bool isActive,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive ? const Color(0xFF136DEC) : (isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard({
    required String imageUrl,
    required String title,
    required String location,
    required String price,
    required String status,
    required bool isActive,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Listing content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: !isActive
                              ? const ColorFilter.matrix([
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0, 0, 0, 1, 0,
                                ])
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF111418),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: price,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : const Color(0xFF111418),
                              ),
                              children: const [
                                TextSpan(
                                  text: '/mo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Toggle Switch
                          Switch(
                            value: isActive,
                            onChanged: (_) {},
                            activeColor: const Color(0xFF136DEC),
                            activeTrackColor: const Color(0xFF136DEC).withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
          ),
          // Actions
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFF9CA3AF)),
                  label: Text(
                    'Edit Listing',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF111418),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    isActive ? Icons.bar_chart : Icons.visibility,
                    size: 20,
                    color: const Color(0xFF9CA3AF),
                  ),
                  label: Text(
                    isActive ? 'Stats' : 'Preview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF111418),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}