import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'add_listing_controller.dart';
import 'add_listing_step7_review.dart';

/// Step 6 – House Rules
class AddListingStep6RulesScreen extends StatefulWidget {
  const AddListingStep6RulesScreen({super.key, required this.controller});
  final AddListingController controller;

  @override
  State<AddListingStep6RulesScreen> createState() =>
      _AddListingStep6RulesScreenState();
}

class _AddListingStep6RulesScreenState
    extends State<AddListingStep6RulesScreen> {
  static final _ruleGroups = [
    {
      'group': 'STANDARD RULES',
      'items': [
        {'key': 'no_smoking', 'icon': Icons.smoke_free, 'label': 'No smoking'},
        {'key': 'no_parties', 'icon': Icons.celebration, 'label': 'No parties or events'},
        {'key': 'pets_allowed', 'icon': Icons.pets, 'label': 'Pets allowed'},
        {'key': 'quiet_hours', 'icon': Icons.access_time_filled, 'label': 'Quiet hours (22:00 - 08:00)'},
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
              step: 6, total: 7, fraction: 6 / 7, label: 'House Rules'),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text(
                    'Set your house rules',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guests must agree to your rules before they book.',
                    style: TextStyle(
                        fontSize: 15, color: c.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Group rows
                  for (final group in _ruleGroups) ...[
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
                      _RuleRow(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        checked: widget.controller.houseRules[item['key']] ?? false,
                        onChanged: (_) {
                          setState(() {
                            widget.controller.toggleHouseRule(item['key'] as String);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddListingStep7ReviewScreen(controller: widget.controller),
            ),
          );
        },
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({
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
