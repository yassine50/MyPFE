import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'add_listing_controller.dart';
import 'add_listing_step4_details.dart';

/// Step 3 – Photos
class AddListingStep3PhotosScreen extends StatefulWidget {
  const AddListingStep3PhotosScreen({super.key, required this.controller});
  final AddListingController controller;

  @override
  State<AddListingStep3PhotosScreen> createState() =>
      _AddListingStep3PhotosScreenState();
}

class _AddListingStep3PhotosScreenState
    extends State<AddListingStep3PhotosScreen> {
  bool _isUploading = false;

  void _removePhoto(int index) {
    setState(() {
      widget.controller.photoUrls.removeAt(index);
      if (index < widget.controller.photoLabels.length) {
        widget.controller.photoLabels.removeAt(index);
      }
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final localPath = pickedFile.path;

    setState(() {
      _isUploading = true;
      widget.controller.photoUrls.add(localPath);
      widget.controller.photoLabels.add('Uploading...');
    });

    try {
      final file = File(localPath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final ref = FirebaseStorage.instance.ref().child('listings/temp_uploads/$fileName');

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      if (mounted) {
        setState(() {
          final index = widget.controller.photoUrls.indexOf(localPath);
          if (index != -1) {
            widget.controller.photoUrls[index] = downloadUrl;
            widget.controller.photoLabels[index] = 'Photo';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          final index = widget.controller.photoUrls.indexOf(localPath);
          if (index != -1) {
            widget.controller.photoUrls.removeAt(index);
            widget.controller.photoLabels.removeAt(index);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final photos = widget.controller.photoUrls;
    final labels = widget.controller.photoLabels;

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
          _ProgressBar(step: 3, total: 5, fraction: 0.6, label: 'Photos'),

          // ── Scrollable Content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Headline
                  Text(
                    'Add photos of\nyour place',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: c.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Renters love high-quality photos. Start with at least 5 photos showing the most important areas.',
                    style: TextStyle(
                      fontSize: 15,
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upload Zone
                  GestureDetector(
                    onTap: _isUploading ? null : _pickAndUploadImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                      decoration: BoxDecoration(
                        color: c.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isUploading ? c.primary : c.inputBorder,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_isUploading)
                            CircularProgressIndicator(color: c.primary)
                          else ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: c.card,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.add_a_photo_outlined,
                                  size: 32, color: c.primary),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Upload Photos',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: c.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to select an image from gallery',
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG up to 10MB',
                              style: TextStyle(
                                fontSize: 12,
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Photos header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Photos (${photos.length})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c.textMain,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Reorder',
                          style: TextStyle(
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Photos Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 4 / 3,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, i) {
                      final label = i < labels.length ? labels[i] : '';
                      final isCover = i == 0;
                      return _PhotoCard(
                        url: photos[i],
                        label: label,
                        isCover: isCover,
                        onDelete: () => _removePhoto(i),
                        c: c,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Tip card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: c.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Tip',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: c.textMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Horizontal photos work best. Avoid flash and try to use natural light by opening curtains.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: c.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
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

      bottomSheet: _BottomNav(
        onBack: () => Navigator.pop(context),
        onNext: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AddListingStep4DetailsScreen(controller: widget.controller),
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatefulWidget {
  const _PhotoCard({
    required this.url,
    required this.label,
    required this.isCover,
    required this.onDelete,
    required this.c,
  });

  final String url;
  final String label;
  final bool isCover;
  final VoidCallback onDelete;
  final AppColorScheme c;

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.url.startsWith('http')
                ? Image.network(
                    widget.url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => Container(
                      color: widget.c.inputBorder,
                      child: Icon(Icons.image_outlined,
                          color: widget.c.textSecondary, size: 32),
                    ),
                  )
                : Image.file(
                    File(widget.url),
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => Container(
                      color: widget.c.inputBorder,
                      child: Icon(Icons.broken_image_outlined,
                          color: widget.c.textSecondary, size: 32),
                    ),
                  ),

            // Cover badge
            if (widget.isCover)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Cover Photo',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

            // Delete button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: AnimatedOpacity(
                  opacity: _hovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ),

            // Label at bottom
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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

// ─── Shared widgets re-exported from step2 ──────────────────────────────────────
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
