import 'package:flutter/material.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/utils/currency_formatter.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedRoomsPageState();
}

class _SavedRoomsPageState extends State<Saved> {
  int _selectedFilterIndex = 0;

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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text('Please log in to see saved rooms.', style: TextStyle(color: c.textSecondary)),
      );
    }

    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('favorites/${user.uid}').onValue,
      builder: (context, favoritesSnapshot) {
        if (favoritesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoritesData = favoritesSnapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
        if (favoritesData == null || favoritesData.isEmpty) {
          return Center(
            child: Text('No saved rooms yet.', style: TextStyle(color: c.textSecondary)),
          );
        }

        final favoriteIds = favoritesData.keys.map((e) => e.toString()).toSet();

        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref('properties').onValue,
          builder: (context, propertiesSnapshot) {
            if (propertiesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final propertiesData = propertiesSnapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
            if (propertiesData == null) {
              return Center(
                child: Text('No properties found.', style: TextStyle(color: c.textSecondary)),
              );
            }

            final List<PropertyModel> savedProperties = [];
            propertiesData.forEach((key, value) {
              if (favoriteIds.contains(key.toString())) {
                savedProperties.add(PropertyModel.fromJson(value as Map<dynamic, dynamic>, key.toString()));
              }
            });

            if (savedProperties.isEmpty) {
              return Center(
                child: Text('No saved properties found.', style: TextStyle(color: c.textSecondary)),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedProperties.length,
              separatorBuilder: (context, index) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                final property = savedProperties[index];
                return _buildRoomCard(property, c);
              },
            );
          },
        );
      },
    );
  }

  // Room Card
  Widget _buildRoomCard(PropertyModel room, AppColorScheme c) {
    final imageUrl = room.images.isNotEmpty ? room.images.first : 'https://placehold.co/400x400/png';

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
                  imageUrl,
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
                        icon: Icons.favorite,
                        c: c,
                        iconColor: Colors.red,
                        onTap: () {
                          _toggleFavorite(room.id);
                        },
                      ),
                    ],
                  ),
                ),

                // Badge at Bottom Left
                if (room.isColiving)
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
                      room.title,
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
                        room.rating,
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
                room.subtitle,
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
                  ValueListenableBuilder<String>(
                    valueListenable: CurrencyFormatter.symbolNotifier,
                    builder: (context, symbol, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            room.displayPrice,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: c.primary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Remove Button
                  GestureDetector(
                    onTap: () {
                      _removeRoom(room.id);
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
  Widget _buildBadge(PropertyModel room, AppColorScheme c) {
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
            'Coliving',
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
  void _toggleFavorite(String roomId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref('favorites/${user.uid}/$roomId');
      await ref.remove();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
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
                _toggleFavorite(roomId);
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
  void _shareRoom(PropertyModel room) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${room.title}...'),
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
