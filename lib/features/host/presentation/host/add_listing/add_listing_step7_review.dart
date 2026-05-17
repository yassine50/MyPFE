import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_listing_controller.dart';
import 'manage_listing.dart';
import 'package:pfe/core/utils/currency_formatter.dart';

/// Step 7 – Review & Publish
class AddListingStep7ReviewScreen extends StatefulWidget {
  const AddListingStep7ReviewScreen({super.key, required this.controller});
  final AddListingController controller;

  @override
  State<AddListingStep7ReviewScreen> createState() => _AddListingStep7ReviewScreenState();
}

class _AddListingStep7ReviewScreenState extends State<AddListingStep7ReviewScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final amenities = widget.controller.selectedAmenityLabels;

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
              step: 7, total: 7, fraction: 1.0, label: 'Review & Publish'),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text(
                    'Review your listing',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Here's what guests will see. Make sure everything looks good before publishing.",
                    style: TextStyle(
                        fontSize: 15, color: c.textSecondary, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // ── Listing Preview Card ─────────────────────────────
                  _ListingPreviewCard(controller: widget.controller, c: c),

                  const SizedBox(height: 28),
                  Divider(color: c.border),
                  const SizedBox(height: 24),

                  // ── Listing Details ──────────────────────────────────
                  _ReviewSection(
                    title: 'Listing details',
                    onEdit: () => Navigator.pop(context),
                    child: Column(
                      children: [
                        _ReviewRow(
                          label: 'Title',
                          value: widget.controller.title.isEmpty
                              ? 'Modern Co-living Space in Victoriei'
                              : widget.controller.title,
                          showBorder: true,
                          c: c,
                        ),
                        _ReviewRow(
                          label: 'Description',
                          value: widget.controller.description.isEmpty
                              ? 'Enjoy a stylish experience at this centrally-located place...'
                              : widget.controller.description,
                          showBorder: true,
                          c: c,
                        ),
                        _ReviewRow(
                          label: 'Basics',
                          value:
                              '${widget.controller.guests} Guests, ${widget.controller.bedrooms} Bedroom${widget.controller.bedrooms != 1 ? 's' : ''}, ${widget.controller.bathrooms} Bath',
                          showBorder: false,
                          c: c,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Location ─────────────────────────────────────────
                  _ReviewSection(
                    title: 'Location',
                    onEdit: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.controller.streetAddress.isEmpty
                              ? 'Str. Victoriei, nr. 10, Bucharest, 010101'
                              : '${widget.controller.streetAddress}, ${widget.controller.city}, ${widget.controller.zipCode}',
                          style: TextStyle(fontSize: 14, color: c.textMain),
                        ),
                        const SizedBox(height: 12),
                        _MapMiniPreview(c: c),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Amenities ────────────────────────────────────────
                  _ReviewSection(
                    title: 'Amenities',
                    onEdit: () {},
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final a in amenities.take(4))
                          _AmenityChip(label: a, c: c),
                        if (amenities.length > 4)
                          _AmenityChip(
                            label: '+ ${amenities.length - 4} more',
                            c: c,
                            isMuted: true,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Pricing ──────────────────────────────────────────
                  _ReviewSection(
                    title: 'Pricing & Availability',
                    onEdit: () {},
                    child: Column(
                      children: [
                        _ReviewRow(
                          label: 'Nightly Price',
                          value: CurrencyFormatter.format(widget.controller.price.toDouble()),
                          showBorder: true,
                          c: c,
                        ),
                        _ReviewRow(
                          label: 'Discount',
                          value: '20% for monthly stays',
                          valueColor: Colors.green,
                          showBorder: false,
                          c: c,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── House Rules ──────────────────────────────────────
                  _ReviewSection(
                    title: 'House Rules',
                    onEdit: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final rule in widget.controller.selectedHouseRules)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('•  ',
                                    style: TextStyle(
                                        color: c.textSecondary, fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    rule,
                                    style: TextStyle(
                                        fontSize: 14, color: c.textMain),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.controller.selectedHouseRules.isEmpty)
                          Text('No house rules specified.',
                              style: TextStyle(fontSize: 14, color: c.textSecondary)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Legal disclaimer ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: c.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: c.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 13,
                                  color: c.textMain,
                                  height: 1.5),
                              children: const [
                                TextSpan(text: 'By selecting '),
                                TextSpan(
                                  text: 'Publish Listing',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      ', you agree to our Host Terms and acknowledge our Privacy Policy. Your listing will go live immediately.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Navigation ────────────────────────────────────────
      bottomSheet: _PublishBottomBar(
        onBack: () => Navigator.pop(context),
        isLoading: _isLoading,
        onPublish: () async {
          final scaffoldMsg = ScaffoldMessenger.of(context);
          final nav = Navigator.of(context);
          setState(() => _isLoading = true);

          try {
            // Map the controller data to PropertyModel
            final newProperty = PropertyModel(
              id: '', // Generated by Firebase push
              title: widget.controller.title.isNotEmpty ? widget.controller.title : 'New Property',
              subtitle: '${widget.controller.streetAddress}, ${widget.controller.city}',
              price: CurrencyFormatter.format(widget.controller.price.toDouble()),
              rating: 'New',
              images: widget.controller.photoUrls,
              mapImageUrl: '',
              latitude: widget.controller.latitude,
              longitude: widget.controller.longitude,
              isFeatured: true,
              isColiving: true,
              description: widget.controller.description,
              moveInDate: 'Flexible',
              roomType: 'Entire place',
              amenities: widget.controller.selectedAmenityLabels,
              residentDemographics: 'Mixed',
              reviews: [],
              residentAvatars: [],
              houseRules: widget.controller.selectedHouseRules,
              hostId: FirebaseAuth.instance.currentUser?.uid ?? '',
            );

            final repo = PropertyRepository();
            await repo.addProperty(newProperty);

            if (!mounted) return;
            setState(() => _isLoading = false);
            _showSuccess(nav, c, newProperty);
          } catch (e) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            if (!mounted) return;
            scaffoldMsg.showSnackBar(
              SnackBar(content: Text('Error publishing listing: $e')),
            );
          }
        },
      ),
    );
  }

  void _showSuccess(NavigatorState nav, AppColorScheme c, PropertyModel property) {
    nav.push(
      DialogRoute(
        context: nav.context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: c.card,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Colors.green, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'Listing Published!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your property is now live and visible to potential guests.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    nav.pop(); // close dialog
                    nav.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => ManageListingScreen(property: property),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Manage Listing',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

// ── Sub-widgets ─────────────────────────────────────────────────────────────────

class _ListingPreviewCard extends StatelessWidget {
  const _ListingPreviewCard({
    required this.controller,
    required this.c,
  });

  final AddListingController controller;
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    final coverUrl = controller.photoUrls.isNotEmpty
        ? controller.photoUrls.first
        : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: coverUrl.isNotEmpty
                      ? (coverUrl.startsWith('http')
                          ? Image.network(
                              coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, s) => Container(
                                color: c.inputBorder,
                                child: Icon(Icons.image_outlined,
                                    color: c.textSecondary, size: 48),
                              ),
                            )
                          : Image.file(
                              File(coverUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, s) => Container(
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'PREVIEW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.title.isEmpty
                              ? 'Modern Co-living Space in Victoriei'
                              : controller.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: c.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Entire apartment • ${controller.guests} guests • ${controller.bedrooms} bedroom',
                          style: TextStyle(
                              fontSize: 13, color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: CurrencyFormatter.format(controller.price.toDouble()),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: c.textMain),
                          const SizedBox(width: 2),
                          Text(
                            'New',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: c.textMain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.onEdit,
    required this.child,
  });

  final String title;
  final VoidCallback onEdit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: c.textMain,
              ),
            ),
            TextButton(
              onPressed: onEdit,
              child: Text(
                'Edit',
                style: TextStyle(
                  color: c.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.label,
    required this.value,
    required this.showBorder,
    required this.c,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool showBorder;
  final AppColorScheme c;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: showBorder
          ? BoxDecoration(border: Border(bottom: BorderSide(color: c.border)))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: c.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? c.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({
    required this.label,
    required this.c,
    this.isMuted = false,
  });

  final String label;
  final AppColorScheme c;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMuted ? c.card : c.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isMuted ? c.textSecondary : c.textMain,
        ),
      ),
    );
  }
}

class _MapMiniPreview extends StatelessWidget {
  const _MapMiniPreview({required this.c});
  final AppColorScheme c;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD6oENQWkLhjjVXkGS1tsXJNy54ge1OCNZ-jFXlJJXTTRTZ591TGKNI_xFoNfGOC4QW7oyL2rwkouG7wLL2jJpDb_FiRv3Rac60pQuV4Yc5xOfBA5jEJCTxBMcK-8Jk-Axl6cDHVQCVPmzD_HtxtqAtcgwz2WAG52YBdxbTNjnHjSLQ33x29gL0YLvcL6TTjXK49xgk2-fSgQZUXRGAI_Nz4pSx3QSNGjQXiacbS_FsvlNS5uT2_yutsnqBqonuZe9DSyU2wOOb8r4',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.15),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, e, s) => Container(
              height: 120,
              color: c.inputBorder,
              child: Icon(Icons.map_outlined, color: c.textSecondary, size: 36),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: c.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _PublishBottomBar extends StatelessWidget {
  const _PublishBottomBar({
    required this.onBack,
    required this.onPublish,
    this.isLoading = false,
  });
  final VoidCallback? onBack;
  final VoidCallback? onPublish;
  final bool isLoading;

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
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Publish Listing',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              label: isLoading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.check_circle_outline, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
