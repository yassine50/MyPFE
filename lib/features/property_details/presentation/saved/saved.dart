import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedRoomsPageState();
}

class _SavedRoomsPageState extends State<Saved> {
  int _selectedFilterIndex = 0;
  final List<Map<String, dynamic>> _savedRooms = [
    {
      'id': '1',
      'title': 'Cozy Penthouse in Bucharest',
      'location': 'Sector 1, walking distance to Herastrau Park',
      'price': 850,
      'rating': 4.92,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBZvBhM371uLOjgeFlo4r0EZ9HEkngbe7OX42HupmO7GVLKZHFq0GGLs-l23qlDwY55Kq7oWn_ekto3N8pA1Nug85KJSnMNClX08-lTWZOMHCegbmK6qRO0HydAqrm-WVsEg-Bv4s6ms4bkzbJCEMB6A-nNWBdcEePjNvUl3BbQ495O70mi2QZBdMh3r6WfUGzoHXbvji7XObEwaXzJ_TGE0nS6070M0RPP9xVCIG_lGxBWVGybEmEuZQapLnO_Ws3BRvavDqPrC8E',
      'isFavorite': true,
      'badgeType': 'verified',
      'badgeText': 'Verified Host',
    },
    {
      'id': '2',
      'title': 'Modern Co-living Cluj',
      'location': 'Zorilor District, High-speed fiber included',
      'price': 420,
      'rating': 4.85,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA-V2EWkxGKd05n1_EDcGVnmiGx1j0BZPhjN6-Nhu6h4Q6hi6FiIGe0t4VibrwoJCGabE3MGuvo7dk0YKHXF_wiFNnZLS3yTZ7GtBsZK8Qnq4IQlThoPmnmSACWvChw-7L_9TFT_o62DCQRKeyRTvnD8sGcMBh27r4PWyn2TyrkOhn9ZbmoF24FIuyenIwiLRzdgmD3k_KyrdhAZT6REn4xz9KD6yydIUcHO6vZFjAHMmbLXCzupT0a4QxCvVjiUtWKMlqVd4xVT38',
      'isFavorite': true,
      'badgeType': 'professional',
      'badgeText': 'Professional',
    },
    {
      'id': '3',
      'title': 'Luminous Studio Timișoara',
      'location': 'City Center, newly renovated architecture',
      'price': 380,
      'rating': 4.70,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBs5CxfewJGGHHbpTMcJdmbKm4u9B_oabUbdCe0Q9DK0Jitmv6S2Lai_zLs4586P-UInD_E3PfA4OwrqNku7862ptuVtDfHFxE96jA544hOq2b3nKbV2yIckMCUxD2L06lIvYBh95yujBGlycnrmwpjO7tP8CXgnzBJ8DtecTh4BIW6AvfYfXhx-31ZH4UJaT0dOw63FRut8eTJMzIJJrzlv07KN_TwJPzsysohaGhp2GqYJ1Yj8VhNa63usPyGWcF5j_7TgSQo2aQ',
      'isFavorite': true,
      'badgeType': null,
      'badgeText': null,
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Filter Buttons
                    _buildFilterButtons(c),

                    const SizedBox(height: 32),

                    // Saved Rooms List
                    _buildRoomsList(c),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: c.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button

          // Title
          Text(
            AppStrings.savedRoomsTitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              letterSpacing: -0.5,
            ),
          ),

          // More Options Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // Show more options
                _showMoreOptions(c);
              },
              icon: const Icon(Icons.more_horiz, size: 24),
              padding: EdgeInsets.zero,
              color: c.textMain,
            ),
          ),
        ],
      ),
    );
  }

  // Filter Buttons
  Widget _buildFilterButtons(AppColorScheme c) {
    final List<String> filters = [AppStrings.filterAllProperties, AppStrings.filterColiving, AppStrings.filterApartments];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : c.card,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: c.border),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: c.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : c.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Rooms List
  Widget _buildRoomsList(AppColorScheme c) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _savedRooms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 32),
      itemBuilder: (context, index) {
        final room = _savedRooms[index];
        return _buildRoomCard(room, c);
      },
    );
  }

  // Room Card
  Widget _buildRoomCard(Map<String, dynamic> room, AppColorScheme c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with overlays
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Room Image
                Image.network(
                  room['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: c.statsBg,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: c.statsBg,
                      child: const Center(child: Icon(Icons.broken_image)),
                    );
                  },
                ),

                // Top Right Buttons
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Share Button
                      _buildImageActionButton(
                        icon: Icons.share,
                        c: c,
                        onTap: () {
                          _shareRoom(room);
                        },
                      ),
                      const SizedBox(height: 8),
                      // Favorite Button
                      _buildImageActionButton(
                        icon: room['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        c: c,
                        iconColor: Colors.red,
                        onTap: () {
                          _toggleFavorite(room['id']);
                        },
                      ),
                    ],
                  ),
                ),

                // Badge at Bottom Left
                if (room['badgeType'] != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: _buildBadge(room, c),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Room Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      room['title'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        room['rating'].toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: c.textMain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Location
              Text(
                room['location'],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: c.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Price and Remove Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '€${room['price']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: c.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.perMonth,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Remove Button
                  GestureDetector(
                    onTap: () {
                      _removeRoom(room['id']);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: c.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.removeButton,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Image Action Button
  Widget _buildImageActionButton({
    required IconData icon,
    required AppColorScheme c,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.card.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? c.textMain, size: 20),
      ),
    );
  }

  // Badge Widget
  Widget _buildBadge(Map<String, dynamic> room, AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          Icon(Icons.verified, color: c.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            room['badgeText']!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Show More Options
  void _showMoreOptions(AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                icon: Icons.sort,
                label: AppStrings.sortBy,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  _showSortOptions(c);
                },
              ),
              _buildOptionItem(
                icon: Icons.filter_list,
                label: AppStrings.filter,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Show filter options
                },
              ),
              _buildOptionItem(
                icon: Icons.download,
                label: AppStrings.exportList,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Export functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.share,
                label: AppStrings.shareList,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  _shareAllRooms();
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: c.border, height: 1),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppStrings.cancel,
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
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textMain,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: c.textSecondary),
      onTap: onTap,
    );
  }

  // Show Sort Options
  void _showSortOptions(AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppStrings.sortBy,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption(
                label: AppStrings.priceLowToHigh,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Sort logic
                },
              ),
              _buildSortOption(
                label: AppStrings.priceHighToLow,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Sort logic
                },
              ),
              _buildSortOption(
                label: AppStrings.rating,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Sort logic
                },
              ),
              _buildSortOption(
                label: AppStrings.dateSaved,
                c: c,
                onTap: () {
                  Navigator.pop(context);
                  // Sort logic
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: c.border, height: 1),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppStrings.cancel,
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
        );
      },
    );
  }

  // Sort Option
  Widget _buildSortOption({
    required String label,
    required AppColorScheme c,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textMain,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Toggle Favorite
  void _toggleFavorite(String roomId) {
    setState(() {
      final index = _savedRooms.indexWhere((room) => room['id'] == roomId);
      if (index != -1) {
        _savedRooms[index]['isFavorite'] = !_savedRooms[index]['isFavorite'];

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _savedRooms[index]['isFavorite']
                  ? 'Added to favorites'
                  : 'Removed from favorites',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // Remove Room
  void _removeRoom(String roomId) {
    showDialog(
      context: context,
      builder: (context) {
        final c = context.appColors;

        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Remove from Saved',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textMain,
            ),
          ),
          content: Text(
            'Are you sure you want to remove this property from your saved list?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: c.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppStrings.cancel,
                style: GoogleFonts.plusJakartaSans(
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
                  _savedRooms.removeWhere((room) => room['id'] == roomId);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Property removed from saved list'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                AppStrings.removeButton,
                style: GoogleFonts.plusJakartaSans(
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

  // Share Room
  void _shareRoom(Map<String, dynamic> room) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${room['title']}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Share All Rooms
  void _shareAllRooms() {
    // Implement share all functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing saved rooms list...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
