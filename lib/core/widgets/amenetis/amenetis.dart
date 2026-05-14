import 'package:flutter/material.dart';

class Amenetis extends StatelessWidget {
  const Amenetis({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: const [
            _AmenityItem(icon: Icons.wifi, label: "Fast Wi-Fi"),
            _AmenityItem(icon: Icons.kitchen, label: "Full Kitchen"),
            _AmenityItem(
              icon: Icons.local_laundry_service,
              label: "Washer/Dryer",
            ),
            _AmenityItem(icon: Icons.ac_unit, label: "Air Conditioning"),
            _AmenityItem(icon: Icons.balcony, label: "Balcony"),
            _AmenityItem(icon: Icons.work, label: "Desk Area"),
          ],
        ),

        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(
              color: Color.fromARGB(255, 228, 225, 225), // 👈 outline color
            ),
            foregroundColor: Colors.black, // 👈 text (and icon) color
          ),
          child: const Text("Show all 15 amenities"),
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
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
