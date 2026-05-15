import 'package:flutter/material.dart';

class Amenetis extends StatelessWidget {
  final List<String> amenities;

  const Amenetis({super.key, required this.amenities});

  IconData _getIconForAmenity(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
      case 'internet':
        return Icons.wifi;
      case 'kitchen':
        return Icons.kitchen;
      case 'laundry':
      case 'washer':
      case 'dryer':
        return Icons.local_laundry_service;
      case 'ac':
      case 'air conditioning':
        return Icons.ac_unit;
      case 'balcony':
        return Icons.balcony;
      case 'desk':
      case 'workspace':
        return Icons.work;
      case 'tv':
        return Icons.tv;
      case 'heating':
        return Icons.thermostat;
      case 'parking':
        return Icons.local_parking;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _getLabelForAmenity(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return 'Fast Wi-Fi';
      case 'kitchen':
        return 'Full Kitchen';
      case 'laundry':
        return 'Washer/Dryer';
      case 'ac':
        return 'Air Conditioning';
      case 'balcony':
        return 'Balcony';
      case 'desk':
        return 'Desk Area';
      case 'tv':
        return 'Smart TV';
      case 'heating':
        return 'Heating';
      case 'parking':
        return 'Free Parking';
      default:
        // Capitalize first letter
        if (amenity.isEmpty) return amenity;
        return amenity[0].toUpperCase() + amenity.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    // Show up to 6 amenities in the grid
    final displayAmenities = amenities.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Amenities",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
          children: displayAmenities.map((amenity) {
            return _AmenityItem(
              icon: _getIconForAmenity(amenity),
              label: _getLabelForAmenity(amenity),
            );
          }).toList(),
        ),

        if (amenities.length > 6)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: Color.fromARGB(255, 228, 225, 225),
                ),
                foregroundColor: Colors.black,
              ),
              child: Text("Show all ${amenities.length} amenities"),
            ),
          ),
      ],
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 22),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            label, 
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
