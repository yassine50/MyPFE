import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'add_listing_controller.dart';
import 'add_listing_step3_photos.dart';

/// Step 2 – Location & Basics
class AddListingStep2LocationScreen extends StatefulWidget {
  const AddListingStep2LocationScreen({super.key, required this.controller});
  final AddListingController controller;

  @override
  State<AddListingStep2LocationScreen> createState() =>
      _AddListingStep2LocationScreenState();
}

class _AddListingStep2LocationScreenState
    extends State<AddListingStep2LocationScreen> {
  late final TextEditingController _streetCtrl;
  late final TextEditingController _aptCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _zipCtrl;

  @override
  void initState() {
    super.initState();
    _streetCtrl = TextEditingController(text: widget.controller.streetAddress);
    _aptCtrl = TextEditingController(text: widget.controller.apartment);
    _cityCtrl = TextEditingController(text: widget.controller.city);
    _zipCtrl = TextEditingController(text: widget.controller.zipCode);
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _aptCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    widget.controller.streetAddress = _streetCtrl.text.trim();
    widget.controller.apartment = _aptCtrl.text.trim();
    widget.controller.city = _cityCtrl.text.trim();
    widget.controller.zipCode = _zipCtrl.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddListingStep3PhotosScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.card,
      body: Column(
        children: [
          // ── Top App Bar ──────────────────────────────────────────
          _TopBar(
            onBack: () => Navigator.pop(context),
            onSaveExit: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),

          // ── Progress ─────────────────────────────────────────────
          _ProgressBar(step: 2, total: 5, fraction: 0.4, label: 'Location & Basics'),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text(
                    'Where is your\nplace located?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guests will only get your exact address once they have booked a reservation.',
                    style: TextStyle(fontSize: 15, color: c.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Street Address
                  _SectionLabel('Street Address'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _streetCtrl,
                    hint: 'e.g. Str. Victoriei, nr. 10',
                    suffix: Icon(Icons.location_on_outlined, color: c.textSecondary),
                  ),

                  const SizedBox(height: 16),

                  // Apartment (optional)
                  _SectionLabel('Apartment, suite, etc. (Optional)'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _aptCtrl,
                    hint: 'e.g. Apt 4B',
                  ),

                  const SizedBox(height: 16),

                  // City + Zip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel('City / Sector'),
                            const SizedBox(height: 8),
                            _InputField(controller: _cityCtrl, hint: 'Bucharest'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel('Zip Code'),
                            const SizedBox(height: 8),
                            _InputField(
                              controller: _zipCtrl,
                              hint: '010101',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Map preview (Interactive)
                  _InteractiveMapPreview(
                    c: c,
                    controller: widget.controller,
                  ),

                  const SizedBox(height: 28),
                  Divider(color: c.border),
                  const SizedBox(height: 20),

                  // Basics
                  Text(
                    'Basics about your place',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Counters
                  _CounterRow(
                    label: 'Guests',
                    subLabel: 'Max capacity',
                    value: widget.controller.guests,
                    onDecrement: () =>
                        setState(() => widget.controller.updateGuests(-1)),
                    onIncrement: () =>
                        setState(() => widget.controller.updateGuests(1)),
                    showBorder: true,
                    c: c,
                  ),
                  _CounterRow(
                    label: 'Bedrooms',
                    value: widget.controller.bedrooms,
                    onDecrement: () =>
                        setState(() => widget.controller.updateBedrooms(-1)),
                    onIncrement: () =>
                        setState(() => widget.controller.updateBedrooms(1)),
                    showBorder: true,
                    c: c,
                  ),
                  _CounterRow(
                    label: 'Bathrooms',
                    value: widget.controller.bathrooms,
                    onDecrement: () =>
                        setState(() => widget.controller.updateBathrooms(-1)),
                    onIncrement: () =>
                        setState(() => widget.controller.updateBathrooms(1)),
                    showBorder: false,
                    c: c,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: _BottomNav(
        onBack: () => Navigator.pop(context),
        onNext: _saveAndNext,
      ),
    );
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onSaveExit});
  final VoidCallback onBack;
  final VoidCallback onSaveExit;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              color: c.textMain,
            ),
            Expanded(
              child: Text(
                'Add New Listing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                ),
              ),
            ),
            TextButton(
              onPressed: onSaveExit,
              child: Text(
                'Save & Exit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: c.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.step,
    required this.total,
    required this.fraction,
    required this.label,
  });

  final int step;
  final int total;
  final double fraction;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $step of $total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.textMain,
                ),
              ),
              Text(label, style: TextStyle(fontSize: 12, color: c.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: c.inputBorder,
              color: c.primary,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: c.textMain,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.suffix,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final Widget? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15, color: c.textMain),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.textSecondary, fontSize: 15),
        suffixIcon: suffix,
        filled: true,
        fillColor: c.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
      ),
    );
  }
}

class _InteractiveMapPreview extends StatefulWidget {
  const _InteractiveMapPreview({required this.c, required this.controller});
  final AppColorScheme c;
  final AddListingController controller;

  @override
  State<_InteractiveMapPreview> createState() => _InteractiveMapPreviewState();
}

class _InteractiveMapPreviewState extends State<_InteractiveMapPreview> {
  late final MapController _mapController;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = LatLng(
      widget.controller.latitude,
      widget.controller.longitude,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    setState(() {
      _currentCenter = camera.center;
    });
    widget.controller.updateCoordinates(
      _currentCenter.latitude,
      _currentCenter.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: widget.c.inputBorder,
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 14,
                onPositionChanged: _onPositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                ),
              ],
            ),
            // Center Pin
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30), // adjust to make pin point to center
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: widget.c.primary,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.c.card.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Move map to adjust location',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.c.textMain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    this.subLabel,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.showBorder,
    required this.c,
  });

  final String label;
  final String? subLabel;
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool showBorder;
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(bottom: BorderSide(color: c.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textMain,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel!,
                    style: TextStyle(fontSize: 13, color: c.textSecondary),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              _CircleButton(
                icon: Icons.remove,
                onTap: onDecrement,
                c: c,
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
              ),
              _CircleButton(
                icon: Icons.add,
                onTap: onIncrement,
                c: c,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.c,
  });

  final IconData icon;
  final VoidCallback onTap;
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c.inputBorder),
          color: c.card,
        ),
        child: Icon(icon, size: 20, color: c.textMain),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.onBack, required this.onNext});
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.textMain,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            icon: const Text(
              'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            label: const Icon(Icons.arrow_forward, size: 20),
          ),
        ],
      ),
    );
  }
}
