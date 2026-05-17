import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/search_bar/search_bar.dart';
import 'package:pfe/features/property_details/presentation/detail_screen/detail_screen.dart';
import 'package:pfe/core/utils/currency_formatter.dart';

class MapScreen extends StatefulWidget {
  final List<PropertyModel> properties;

  const MapScreen({super.key, required this.properties});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  PropertyModel? _selectedProperty;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    
    // Default center (e.g., Bucharest)
    final initialCenter = widget.properties.isNotEmpty 
      ? LatLng(widget.properties.first.latitude, widget.properties.first.longitude)
      : const LatLng(44.4268, 26.1025);

    return Scaffold(
      backgroundColor: c.background,
      body: ValueListenableBuilder<String>(
        valueListenable: CurrencyFormatter.symbolNotifier,
        builder: (context, symbol, child) {
          return Stack(
            children: [
              // 1. Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
              onTap: (_, __) {
                setState(() {
                  _selectedProperty = null;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: widget.properties.map((prop) {
                  final isSelected = _selectedProperty?.id == prop.id;
                  return Marker(
                    point: LatLng(prop.latitude, prop.longitude),
                    width: 100,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedProperty = prop;
                        });
                        _mapController.move(LatLng(prop.latitude, prop.longitude), 14.0);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? c.primary : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: isSelected ? c.primary : Colors.grey.shade300, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                ),
                                child: Text(
                                  prop.displayPrice.replaceAll(RegExp(r'\s*/\s*month|\s*/\s*mo'), '').split(' ').firstWhere((e) => e.isNotEmpty, orElse: () => ''),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 0,
                                height: 0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: isSelected ? c.primary : Colors.white,
                                      width: 8,
                                    ),
                                    left: const BorderSide(color: Colors.transparent, width: 6),
                                    right: const BorderSide(color: Colors.transparent, width: 6),
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (prop.isFeatured)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 2,
                                    )
                                  ]
                                ),
                                child: const Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Top Floating Layer (Search & Filters)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    c.background.withValues(alpha: 0.9),
                    c.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: c.card,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: Searchbar()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(label: 'Price', icon: Icons.expand_more, c: c),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'Near Metro', icon: Icons.train, isActive: true, c: c),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'Co-living', c: c),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'Entire Place', c: c),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. Right Side Map Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                _MapControlButton(icon: Icons.directions_subway, c: c),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.add, size: 20),
                        ),
                      ),
                      Container(height: 1, width: 40, color: c.border),
                      GestureDetector(
                        onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.remove, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _MapControlButton(icon: Icons.near_me, c: c),
              ],
            ),
          ),

          // 4. Property Preview Card (Bottom Sheet)
          if (_selectedProperty != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _PropertyPreviewCard(property: _selectedProperty!, c: c),
            ),
            
            if (_selectedProperty == null)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.textMain,
                      foregroundColor: c.card,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.format_list_bulleted, size: 18),
                    label: const Text('List View', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final AppColorScheme c;

  const _FilterChip({required this.label, this.icon, this.isActive = false, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? c.primary : c.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? c.primary : c.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)
        ]
      ),
      child: Row(
        children: [
          if (icon != null && isActive) ...[
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : c.textMain,
            ),
          ),
          if (icon != null && !isActive) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 16, color: c.textMain),
          ],
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final AppColorScheme c;

  const _MapControlButton({required this.icon, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)
        ]
      ),
      child: Icon(icon, size: 20, color: c.textMain),
    );
  }
}

class _PropertyPreviewCard extends StatelessWidget {
  final PropertyModel property;
  final AppColorScheme c;

  const _PropertyPreviewCard({required this.property, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))
        ]
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  property.images.isNotEmpty ? property.images.first : 'https://placehold.co/400x400/png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 110,
                    height: 110,
                    color: c.inputBorder,
                    child: Icon(Icons.image_not_supported, color: c.textSecondary),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_border, size: 16, color: c.textMain),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: c.textMain),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(property.rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: c.textMain)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: c.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${property.roomType} • ${property.isColiving ? "Co-living" : "Entire place"}',
                  style: TextStyle(fontSize: 12, color: c.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: property.displayPrice.replaceAll(RegExp(r'\s*/\s*month|\s*/\s*mo'), ''),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: c.textMain),
                        children: [
                          TextSpan(
                            text: ' / month',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: c.textSecondary)
                          )
                        ]
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailScreen(property: property)),
                        );
                      },
                      child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
