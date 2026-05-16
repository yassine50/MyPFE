import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'add_listing_controller.dart';
import 'add_listing_step5_price.dart';

/// Step 4 – Details & Amenities
class AddListingStep4DetailsScreen extends StatefulWidget {
  const AddListingStep4DetailsScreen({super.key, required this.controller});
  final AddListingController controller;

  @override
  State<AddListingStep4DetailsScreen> createState() =>
      _AddListingStep4DetailsScreenState();
}

class _AddListingStep4DetailsScreenState
    extends State<AddListingStep4DetailsScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.controller.title);
    _descCtrl = TextEditingController(text: widget.controller.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  static final _amenityGroups = [
    {
      'group': 'ESSENTIALS',
      'items': [
        {'key': 'wifi', 'icon': Icons.wifi, 'label': 'Fast Wi-Fi'},
        {'key': 'workspace', 'icon': Icons.desk, 'label': 'Dedicated Workspace'},
        {'key': 'kitchen', 'icon': Icons.countertops, 'label': 'Kitchen'},
        {'key': 'washer', 'icon': Icons.local_laundry_service, 'label': 'Washer'},
      ],
    },
    {
      'group': 'COMFORT',
      'items': [
        {'key': 'ac', 'icon': Icons.ac_unit, 'label': 'Air Conditioning'},
        {'key': 'heating', 'icon': Icons.thermostat, 'label': 'Heating'},
        {'key': 'furnished', 'icon': Icons.weekend, 'label': 'Fully Furnished'},
      ],
    },
    {
      'group': 'SAFETY',
      'items': [
        {'key': 'smoke_alarm', 'icon': Icons.warning_amber_rounded, 'label': 'Smoke Alarm'},
      ],
    },
  ];

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
          _ProgressBar(
              step: 4, total: 7, fraction: 4 / 7, label: 'Details & Amenities'),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text(
                    'Describe your place',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share what makes your space special for colivers and short-term guests.',
                    style: TextStyle(
                        fontSize: 15, color: c.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  _SectionLabel('Listing Title'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: _titleCtrl,
                    hint: 'e.g. Modern Studio in Old Town',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Short titles work best. Have fun with it.',
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  _SectionLabel('Listing Description'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 5,
                    style: TextStyle(fontSize: 15, color: c.textMain),
                    decoration: InputDecoration(
                      hintText:
                          'Highlight features like fast Wi-Fi, nearby cafes, or community events...',
                      hintStyle:
                          TextStyle(color: c.textSecondary, fontSize: 14),
                      filled: true,
                      fillColor: c.inputBg,
                      contentPadding: const EdgeInsets.all(16),
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mention what makes it perfect for digital nomads or long-term stays.',
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),

                  const SizedBox(height: 28),
                  Divider(color: c.border),
                  const SizedBox(height: 24),

                  // Amenities
                  Text(
                    'What amenities do you offer?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These are the most requested features by colivers.',
                    style: TextStyle(fontSize: 14, color: c.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  // Group rows
                  for (final group in _amenityGroups) ...[
                    Text(
                      group['group'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: c.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final item
                        in group['items'] as List<Map<String, Object>>) ...[
                      _AmenityRow(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        checked: widget.controller.amenities[item['key']] ?? false,
                        onChanged: (_) {
                          setState(() {
                            widget.controller.toggleAmenity(item['key'] as String);
                          });
                        },
                        c: c,
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: _BottomNav(
        onBack: () => Navigator.pop(context),
        onNext: () {
          widget.controller.title = _titleCtrl.text.trim();
          widget.controller.description = _descCtrl.text.trim();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddListingStep5PriceScreen(controller: widget.controller),
            ),
          );
        },
      ),
    );
  }
}

class _AmenityRow extends StatelessWidget {
  const _AmenityRow({
    required this.icon,
    required this.label,
    required this.checked,
    required this.onChanged,
    required this.c,
  });

  final IconData icon;
  final String label;
  final bool checked;
  final ValueChanged<bool?> onChanged;
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: checked ? c.primary.withValues(alpha: 0.06) : c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: checked ? c.primary : c.inputBorder,
            width: checked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: checked ? c.primary : c.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c.textMain,
                ),
              ),
            ),
            Checkbox(
              value: checked,
              onChanged: onChanged,
              activeColor: c.primary,
              side: BorderSide(color: c.inputBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared widgets ─────────────────────────────────────────────────────────────
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
  const _InputField({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 15, color: c.textMain),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.textSecondary, fontSize: 15),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
