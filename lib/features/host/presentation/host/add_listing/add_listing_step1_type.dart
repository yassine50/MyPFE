import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'add_listing_controller.dart';
import 'add_listing_step2_location.dart';

/// Entry point: Step 1 - Choose property type
class AddListingStep1TypeScreen extends StatefulWidget {
  const AddListingStep1TypeScreen({super.key});

  @override
  State<AddListingStep1TypeScreen> createState() => _AddListingStep1TypeScreenState();
}

class _AddListingStep1TypeScreenState extends State<AddListingStep1TypeScreen> {
  int _selectedType = -1;

  static const List<Map<String, dynamic>> _types = [
    {'icon': Icons.apartment, 'label': 'Apartment', 'desc': 'Entire floor of a building'},
    {'icon': Icons.home, 'label': 'House', 'desc': 'A standalone residence'},
    {'icon': Icons.bed, 'label': 'Private Room', 'desc': 'A room in a shared home'},
    {'icon': Icons.weekend, 'label': 'Co-living', 'desc': 'Shared community space'},
    {'icon': Icons.villa, 'label': 'Studio', 'desc': 'Open-plan single room'},
    {'icon': Icons.other_houses, 'label': 'Other', 'desc': 'Something unique'},
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.card,
      body: Column(
        children: [
          // ── Top App Bar ──────────────────────────────────────────
          SafeArea(
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
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () => Navigator.pop(context),
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
          ),

          // ── Progress Bar ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step 1 of 5',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.textMain,
                      ),
                    ),
                    Text(
                      'Property Type',
                      style: TextStyle(fontSize: 12, color: c.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: 0.2,
                    backgroundColor: c.inputBorder,
                    color: c.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What kind of place\nwill you list?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the type that best describes your property.',
                    style: TextStyle(fontSize: 16, color: c.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: _types.length,
                    itemBuilder: (context, i) {
                      final item = _types[i];
                      final selected = _selectedType == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selected
                                ? c.primary.withValues(alpha: 0.08)
                                : c.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? c.primary : c.inputBorder,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: selected ? c.primary : c.textSecondary,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['label'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: c.textMain,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['desc'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: c.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Navigation ─────────────────────────────────────
      bottomSheet: _BottomNav(
        onBack: () => Navigator.pop(context),
        onNext: _selectedType >= 0
            ? () {
                final ctrl = AddListingController();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddListingStep2LocationScreen(controller: ctrl),
                  ),
                );
              }
            : null,
        nextLabel: 'Next',
        showArrow: true,
      ),
    );
  }
}

// ─── Shared Bottom Navigation Bar ──────────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Next',
    this.showArrow = true,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return _BottomNav(
      onBack: onBack,
      onNext: onNext,
      nextLabel: nextLabel,
      showArrow: showArrow,
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Next',
    this.showArrow = true,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool showArrow;

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
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: c.primary.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nextLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showArrow) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
