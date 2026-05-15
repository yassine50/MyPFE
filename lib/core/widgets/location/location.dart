import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Location extends StatelessWidget {
  final String locationName;
  final String mapImageUrl;
  final double latitude;
  final double longitude;
  
  const Location({
    super.key, 
    required this.locationName, 
    required this.mapImageUrl,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final displayLat = (latitude == 0.0 && longitude == 0.0) ? 44.4268 : latitude;
    final displayLng = (latitude == 0.0 && longitude == 0.0) ? 26.1025 : longitude;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          locationName,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(displayLat, displayLng),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(displayLat, displayLng),
                        width: 44,
                        height: 44,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 6),
                                ],
                              ),
                              child: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            Container(
                              width: 6,
                              height: 6,
                              transform: Matrix4.rotationZ(0.785),
                              color: Colors.blue.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
