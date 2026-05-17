import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';

class EditListingDetailsScreen extends StatefulWidget {
  final PropertyModel property;
  const EditListingDetailsScreen({super.key, required this.property});

  @override
  State<EditListingDetailsScreen> createState() => _EditListingDetailsScreenState();
}

class _EditListingDetailsScreenState extends State<EditListingDetailsScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _demographicsCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _titleCtrl = TextEditingController(text: p.title);
    _subtitleCtrl = TextEditingController(text: p.subtitle);
    _descCtrl = TextEditingController(text: p.description);
    // Extract numeric price
    final match = RegExp(r'(\d+)').firstMatch(p.price);
    _priceCtrl = TextEditingController(text: match?.group(1) ?? '');
    _demographicsCtrl = TextEditingController(text: p.residentDemographics);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _demographicsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final price = _priceCtrl.text.trim();
    if (title.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and price are required.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await FirebaseDatabase.instance.ref('properties/${widget.property.id}').update({
        'title': title,
        'subtitle': _subtitleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'price': '€$price/month',
        'residentDemographics': _demographicsCtrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
                      child: Text('Edit Details',
                        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isSaving ? null : _save,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(10)),
                      child: _isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Save', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            if (_isSaving) const LinearProgressIndicator(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('Title', _titleCtrl, c, hint: 'e.g. Modern Studio in Bucharest'),
                    const SizedBox(height: 16),
                    _field('Location / Subtitle', _subtitleCtrl, c, hint: 'e.g. Unirii, Bucharest'),
                    const SizedBox(height: 16),
                    _field('Price per month (€)', _priceCtrl, c,
                        hint: 'e.g. 500', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _field('Description', _descCtrl, c,
                        hint: 'Describe your listing...', maxLines: 5),
                    const SizedBox(height: 16),
                    _field('Resident Demographics', _demographicsCtrl, c,
                        hint: 'e.g. 70% Students, 30% Professionals', maxLines: 2),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Save Changes',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _field(String label, TextEditingController ctrl, AppColorScheme c,
      {String hint = '', int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: c.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(fontSize: 15, color: c.textMain),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: c.textSecondary.withValues(alpha: 0.5)),
            filled: true,
            fillColor: c.card,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primary, width: 2)),
          ),
        ),
      ],
    );
  }
}
