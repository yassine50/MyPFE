import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ManagePhotosScreen extends StatefulWidget {
  final PropertyModel property;
  const ManagePhotosScreen({super.key, required this.property});

  @override
  State<ManagePhotosScreen> createState() => _ManagePhotosScreenState();
}

class _ManagePhotosScreenState extends State<ManagePhotosScreen> {
  late List<String> _photos;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.property.images);
  }

  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile == null) return;

    setState(() => _isSaving = true);
    try {
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('properties/${widget.property.id}/${DateTime.now().millisecondsSinceEpoch}.jpg');
          
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _photos.add(downloadUrl);
      });
      await _saveToFirebase();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload photo: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _removePhoto(int index) async {
    if (_photos.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must have at least one photo.')),
      );
      return;
    }

    // Optionally delete from FirebaseStorage here.
    setState(() {
      _photos.removeAt(index);
      _isSaving = true;
    });

    try {
      await _saveToFirebase();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveToFirebase() async {
    await FirebaseDatabase.instance.ref('properties/${widget.property.id}').update({
      'images': _photos,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photos updated successfully!'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(color: c.card, border: Border(bottom: BorderSide(color: c.border))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: c.hover, borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: c.textMain),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Manage Photos',
                        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            if (_isSaving) const LinearProgressIndicator(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Photo Action
                    GestureDetector(
                      onTap: _isSaving ? null : _pickAndUploadPhoto,
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.05),
                          border: Border.all(color: c.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 36, color: c.primary),
                            const SizedBox(height: 8),
                            Text('Upload New Photo',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.primary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Your Photos (${_photos.length})',
                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
                    const SizedBox(height: 12),
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 4 / 3,
                      ),
                      itemCount: _photos.length,
                      itemBuilder: (context, i) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(_photos[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (i == 0)
                              Positioned(
                                top: 8, left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            Positioned(
                              top: 4, right: 4,
                              child: GestureDetector(
                                onTap: () => _removePhoto(i),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
