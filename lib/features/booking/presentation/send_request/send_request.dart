import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/models/property_model.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe/features/chat/data/repositories/chat_repository.dart';

class SendRequest extends StatefulWidget {
  final PropertyModel property;
  const SendRequest({super.key, required this.property});

  @override
  State<SendRequest> createState() => _RequestToRentPageState();
}

class _RequestToRentPageState extends State<SendRequest> {
  DateTime _moveInDate = DateTime.now().add(const Duration(days: 30));
  DateTime _moveOutDate = DateTime.now().add(const Duration(days: 60));
  int _guestCount = 1;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _quickFillChips = [
    'Digital Nomad',
    'Student',
    'Quiet & Clean',
    'Non-smoker',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectMoveInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _moveInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _moveInDate) {
      setState(() {
        _moveInDate = picked;
        // Ensure move-out is after move-in
        if (_moveOutDate.isBefore(picked) ||
            _moveOutDate.isAtSameMomentAs(picked)) {
          _moveOutDate = picked.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectMoveOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _moveOutDate,
      firstDate: _moveInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null && picked != _moveOutDate) {
      setState(() {
        _moveOutDate = picked;
      });
    }
  }

  void _incrementGuests() {
    setState(() {
      _guestCount++;
    });
  }

  void _decrementGuests() {
    if (_guestCount > 1) {
      setState(() {
        _guestCount--;
      });
    }
  }

  void _addQuickFillText(String text) {
    final currentText = _messageController.text;
    final newText = currentText.isEmpty ? text : '$currentText $text';
    _messageController.text = newText;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
    setState(() {});
  }

  Future<void> _sendRequest(double total) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      final ref = FirebaseDatabase.instance.ref('bookings').push();

      await ref.set({
        'propertyId': widget.property.id,
        'guestId': uid,
        'moveInDate': _moveInDate.toIso8601String(),
        'moveOutDate': _moveOutDate.toIso8601String(),
        'guests': _guestCount,
        'message': _messageController.text,
        'totalPrice': total,
        'status': 'pending',
        'createdAt': ServerValue.timestamp,
      });

      // Create a chat and send initial message
      if (_messageController.text.isNotEmpty) {
        final chatRepo = ChatRepository();
        final chatId = await chatRepo.createOrGetChat(
          widget.property.id,
          widget.property.hostId,
          uid,
        );
        await chatRepo.sendMessage(chatId, uid, _messageController.text);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Request sent successfully!'),
          backgroundColor: context.appColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final priceStr = widget.property.price.replaceAll(RegExp(r'[^0-9]'), '');
    final pricePerMonth = double.tryParse(priceStr) ?? 450.0;
    final serviceFee = 25.0;
    
    int days = _moveOutDate.difference(_moveInDate).inDays;
    if (days <= 0) days = 1;
    double months = days / 30.0;
    double rentTotal = pricePerMonth * months;
    double total = rentTotal + serviceFee;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(c),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120), // Space for footer
                child: Column(
                  children: [
                    // Property Summary Card
                    _buildPropertySummaryCard(c, pricePerMonth),

                    // Trip Details Section
                    _buildTripDetailsSection(c),

                    // Message Section
                    _buildMessageSection(c),

                    // Price Breakdown
                    _buildPriceBreakdown(
                      c,
                      pricePerMonth,
                      months,
                      rentTotal,
                      serviceFee,
                      total,
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Footer
            _buildFooter(c, total),
          ],
        ),
      ),
    );
  }

  // Top App Bar
  Widget _buildTopAppBar(AppColorScheme c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: c.card,
        border: Border(bottom: BorderSide(color: c.border, width: 1)),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: c.card,
              ),
              child: Icon(
                Icons.arrow_back,
                color: c.textMain,
                size: 24,
              ),
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: Text(
                'Request to Book',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: c.textMain,
                  height: 1.2,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),

          // Spacer for alignment
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // Property Summary Card
  Widget _buildPropertySummaryCard(AppColorScheme c, double price) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Property Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.property.roomType,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: c.primary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.property.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${price.toInt()}€ / month',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Property Image
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.property.images.isNotEmpty ? widget.property.images.first : 'https://placehold.co/400x400/png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Trip Details Section
  Widget _buildTripDetailsSection(AppColorScheme c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Trip Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
            ),
          ),
        ),

        // Date Pickers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Move-in Date
              Expanded(
                child: _buildDatePicker(
                  label: 'Move-in Date',
                  date: _moveInDate,
                  onTap: _selectMoveInDate,
                  c: c,
                ),
              ),

              const SizedBox(width: 12),

              // Move-out Date
              Expanded(
                child: _buildDatePicker(
                  label: 'Move-out Date',
                  date: _moveOutDate,
                  onTap: _selectMoveOutDate,
                  c: c,
                ),
              ),
            ],
          ),
        ),

        // Guest Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildGuestSelector(c),
        ),
      ],
    );
  }

  // Date Picker Widget
  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required AppColorScheme c,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(date),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: c.textMain,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month,
                  color: c.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Guest Selector Widget
  Widget _buildGuestSelector(AppColorScheme c) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Icon
          Icon(Icons.group, color: c.textSecondary, size: 24),
          const SizedBox(width: 12),

          // Label
          Expanded(
            child: Text(
              'Guests',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: c.textMain,
              ),
            ),
          ),

          // Counter
          Container(
            decoration: BoxDecoration(
              color: c.counterBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Decrement Button
                GestureDetector(
                  onTap: _decrementGuests,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c.counterBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '-',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Count
                Container(
                  width: 32,
                  height: 32,
                  color: c.counterBg,
                  child: Center(
                    child: Text(
                      _guestCount.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: c.textMain,
                      ),
                    ),
                  ),
                ),

                // Increment Button
                GestureDetector(
                  onTap: _incrementGuests,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c.counterBg,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Message Section
  Widget _buildMessageSection(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Message the Landlord',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.textMain,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 4),

          // Description
          Text(
            'Introduce yourself and mention why you\'d be a great tenant.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: c.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Text Area
          Container(
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _messageController,
              maxLines: 6,
              minLines: 6,
              decoration: InputDecoration(
                hintText:
                    'Hi! I\'m moving to Romania for work and looking for a quiet place to stay...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: c.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: c.textMain,
              ),
              cursorColor: c.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Quick Fill Chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickFillChips.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final chip = _quickFillChips[index];
                return GestureDetector(
                  onTap: () => _addQuickFillText(chip),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chip,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Price Breakdown
  Widget _buildPriceBreakdown(
    AppColorScheme c,
    double price,
    double months,
    double rentTotal,
    double serviceFee,
    double total,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Price per month
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${price.toInt()}€ x ${months.toStringAsFixed(1)} months',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
                Text(
                  '${rentTotal.toInt()}€',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Service fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service fee',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
                Text(
                  '${serviceFee.toInt()}€',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: c.divider, height: 1),
            ),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
                Text(
                  '${total.toInt()}€',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textMain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Sticky Footer
  Widget _buildFooter(AppColorScheme c, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        border: Border(top: BorderSide(color: c.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Lock Icon and Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: c.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                'You won\'t be charged yet',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Send Request Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _sendRequest(total),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: c.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Send Request',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
