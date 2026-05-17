import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  final PropertyModel property;

  const ManageAvailabilityScreen({super.key, required this.property});

  @override
  State<ManageAvailabilityScreen> createState() => _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  late List<String> _blockedDates;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _blockedDates = List.from(widget.property.blockedDates);
  }

  Future<void> _addBlockedDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.appColors.primary,
              onPrimary: Colors.white,
              onSurface: context.appColors.textMain,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(picked);
      if (!_blockedDates.contains(dateStr)) {
        setState(() {
          _blockedDates.add(dateStr);
          _blockedDates.sort(); // Keep them ordered
        });
        _saveToFirebase();
      }
    }
  }

  Future<void> _addBlockedDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.appColors.primary,
              onPrimary: Colors.white,
              onSurface: context.appColors.textMain,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        DateTime current = picked.start;
        while (!current.isAfter(picked.end)) {
          final dateStr = DateFormat('yyyy-MM-dd').format(current);
          if (!_blockedDates.contains(dateStr)) {
            _blockedDates.add(dateStr);
          }
          current = current.add(const Duration(days: 1));
        }
        _blockedDates.sort();
      });
      _saveToFirebase();
    }
  }

  Future<void> _removeDate(String dateStr) async {
    setState(() {
      _blockedDates.remove(dateStr);
    });
    _saveToFirebase();
  }

  Future<void> _saveToFirebase() async {
    setState(() => _isSaving = true);
    try {
      final ref = FirebaseDatabase.instance.ref('properties/${widget.property.id}');
      await ref.update({'blockedDates': _blockedDates});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Availability updated!'), duration: Duration(seconds: 2)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
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
                      child: Text('Manage Availability',
                        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addBlockedDate,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Block Date'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addBlockedDateRange,
                      icon: const Icon(Icons.date_range, size: 18),
                      label: const Text('Block Range'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: c.primary,
                        side: BorderSide(color: c.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_isSaving) const LinearProgressIndicator(),

            // List of blocked dates
            Expanded(
              child: _blockedDates.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_available, size: 64, color: c.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text('All dates are available!',
                            style: GoogleFonts.plusJakartaSans(fontSize: 16, color: c.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _blockedDates.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final dateStr = _blockedDates[index];
                        final date = DateTime.tryParse(dateStr);
                        final displayDate = date != null ? DateFormat('EEEE, MMM d, yyyy').format(date) : dateStr;
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: c.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: c.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                                child: const Icon(Icons.block, color: Colors.red, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(displayDate,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: c.textMain)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removeDate(dateStr),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
