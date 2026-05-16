import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/models/property_model.dart';

/// Manage Listing screen shown after a listing is published
class ManageListingScreen extends StatefulWidget {
  const ManageListingScreen({super.key, required this.property});
  final PropertyModel property;

  @override
  State<ManageListingScreen> createState() => _ManageListingScreenState();
}

class _ManageListingScreenState extends State<ManageListingScreen> {
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────
            Container(
              color: c.card,
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
                      'Manage Listing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                      ),
                    ),
                  ),
                  // Spacer to balance the back button
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Listing Preview Card ──────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _ListingPreviewCard(
                        c: c,
                        isActive: _isActive,
                        property: widget.property,
                      ),
                    ),

                    // ── Performance Stats ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance (Last 7 Days)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: Icons.visibility_outlined,
                                  label: 'Views',
                                  value: '0',
                                  trend: '-',
                                  c: c,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  icon: Icons.bookmark_outline,
                                  label: 'Requests',
                                  value: '0',
                                  trend: '-',
                                  c: c,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Quick Actions ─────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                            children: [
                              _ActionCard(
                                icon: Icons.edit_outlined,
                                label: 'Edit Details',
                                subLabel: 'Update title, desc, price',
                                iconBgColor: const Color(0xFFEFF6FF),
                                iconColor: const Color(0xFF136DEC),
                                c: c,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Edit details coming soon!')),
                                  );
                                },
                              ),
                              _ActionCard(
                                icon: Icons.calendar_month_outlined,
                                label: 'Availability',
                                subLabel: 'Block dates & rules',
                                iconBgColor: const Color(0xFFF5F3FF),
                                iconColor: const Color(0xFF7C3AED),
                                c: c,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Availability management coming soon!')),
                                  );
                                },
                              ),
                              _ActionCard(
                                icon: Icons.photo_library_outlined,
                                label: 'Photos',
                                subLabel: 'Add or reorder images',
                                iconBgColor: const Color(0xFFFFF7ED),
                                iconColor: const Color(0xFFEA580C),
                                c: c,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Photo management coming soon!')),
                                  );
                                },
                              ),
                              _PremiumActionCard(
                                c: c,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Premium promotion coming soon!')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Listing Status Toggle ─────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: c.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: c.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.pause_circle_outline,
                                          color: c.textSecondary, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Listing Status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: c.textMain,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Active listings appear in search. Turn off to snooze.',
                                    style: TextStyle(
                                        fontSize: 13, color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Switch(
                              value: _isActive,
                              onChanged: (val) =>
                                  setState(() => _isActive = val),
                              activeThumbColor: Colors.white,
                              activeTrackColor: c.primary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── View on map button ────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          side: BorderSide(color: c.border),
                          backgroundColor: c.card,
                        ),
                        icon: Icon(Icons.map_outlined,
                            color: c.textSecondary, size: 20),
                        label: Text(
                          'View listing on map',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: c.textMain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────────

class _ListingPreviewCard extends StatelessWidget {
  const _ListingPreviewCard({
    required this.c,
    required this.isActive,
    required this.property,
  });
  final AppColorScheme c;
  final bool isActive;
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final coverUrl = property.images.isNotEmpty ? property.images.first : '';

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: coverUrl.isNotEmpty
                    ? (coverUrl.startsWith('http')
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: c.inputBorder,
                              child: Icon(Icons.image_outlined,
                                  color: c.textSecondary, size: 48),
                            ),
                          )
                        : Image.file(
                            File(coverUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: c.inputBorder,
                              child: Icon(Icons.image_outlined,
                                  color: c.textSecondary, size: 48),
                            ),
                          ))
                    : Container(
                        color: c.inputBorder,
                        child: Center(
                          child: Icon(Icons.image_outlined,
                              color: c.textSecondary, size: 48),
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Paused',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title.isNotEmpty ? property.title : 'New Property',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.subtitle.isNotEmpty ? property.subtitle : 'No location provided',
                  style: TextStyle(fontSize: 13, color: c.textSecondary),
                ),
                const SizedBox(height: 12),
                Divider(color: c.border),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRICE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: c.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            text: property.price.isNotEmpty ? property.price : '0 lei',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                            children: [
                              TextSpan(
                                text: ' / night',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: c.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: c.primary.withValues(alpha: 0.1),
                        foregroundColor: c.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Preview',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.c,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: c.primary, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(fontSize: 13, color: c.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF07883B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.iconBgColor,
    required this.iconColor,
    required this.c,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final Color iconBgColor;
  final Color iconColor;
  final AppColorScheme c;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: c.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const Spacer(),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subLabel,
                style: TextStyle(fontSize: 11, color: c.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumActionCard extends StatelessWidget {
  const _PremiumActionCard({required this.c, required this.onTap});
  final AppColorScheme c;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: c.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.primary.withValues(alpha: 0.25)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: c.primary.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.campaign, color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    'Promote',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Boost visibility by 3x',
                    style: TextStyle(fontSize: 11, color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
