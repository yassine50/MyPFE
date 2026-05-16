import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class BillingHistoryPage extends StatelessWidget {
  const BillingHistoryPage({super.key});

  final List<Map<String, dynamic>> _transactions = const [
    {'id': 'INV-2024-001', 'title': 'Monthly Rent — Apt Unirii', 'date': '2024-05-01', 'amount': 480.0, 'status': 'paid'},
    {'id': 'INV-2024-002', 'title': 'Monthly Rent — Apt Unirii', 'date': '2024-04-01', 'amount': 480.0, 'status': 'paid'},
    {'id': 'INV-2024-003', 'title': 'Service Fee', 'date': '2024-03-28', 'amount': 24.0, 'status': 'paid'},
    {'id': 'INV-2024-004', 'title': 'Monthly Rent — Regie Studio', 'date': '2024-03-01', 'amount': 350.0, 'status': 'paid'},
    {'id': 'INV-2024-005', 'title': 'Deposit — Regie Studio', 'date': '2024-02-28', 'amount': 700.0, 'status': 'refunded'},
    {'id': 'INV-2024-006', 'title': 'Service Fee', 'date': '2024-02-15', 'amount': 17.5, 'status': 'failed'},
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final total = _transactions.where((t) => t['status'] == 'paid').fold(0.0, (s, t) => s + (t['amount'] as double));

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
                  _backBtn(c, context),
                  Expanded(child: Center(child: Text('Billing History', style: _titleStyle(c)))),
                  IconButton(
                    icon: Icon(Icons.download_outlined, color: c.primary),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Exporting PDF…'), backgroundColor: c.primary, behavior: SnackBarBehavior.floating),
                    ),
                  ),
                ],
              ),
            ),

            // Summary card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [c.primary, c.primary.withValues(alpha: 0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: c.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Paid', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text('€${total.toStringAsFixed(2)}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('${_transactions.where((t) => t['status'] == 'paid').length} transactions',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white60)),
                        ],
                      ),
                    ),
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: const Icon(Icons.receipt_long, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final t = _transactions[i];
                  return _TransactionTile(transaction: t, c: c);
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final AppColorScheme c;
  const _TransactionTile({required this.transaction, required this.c});

  @override
  Widget build(BuildContext context) {
    final status = transaction['status'] as String;
    final isPaid = status == 'paid';
    final isRefunded = status == 'refunded';
    final statusColor = isPaid ? Colors.green : isRefunded ? Colors.blue : Colors.red;
    final statusLabel = isPaid ? 'Paid' : isRefunded ? 'Refunded' : 'Failed';
    final amountPrefix = isRefunded ? '+' : '-';

    final date = DateTime.tryParse(transaction['date'] as String);
    final dateStr = date != null ? DateFormat('dd MMM yyyy').format(date) : '—';

    return GestureDetector(
      onTap: () => _showReceipt(context, transaction, c),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(isPaid ? Icons.check_circle_outline : isRefunded ? Icons.replay : Icons.error_outline,
                  color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction['title'] as String,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: c.textMain),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(dateStr, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: c.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$amountPrefix€${(transaction['amount'] as double).toStringAsFixed(2)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.bold,
                      color: isRefunded ? Colors.blue : c.textMain,
                    )),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(statusLabel, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReceipt(BuildContext context, Map<String, dynamic> t, AppColorScheme c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Receipt', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain)),
            const SizedBox(height: 16),
            _receiptRow('Invoice ID', t['id'] as String, c),
            _receiptRow('Description', t['title'] as String, c),
            _receiptRow('Date', t['date'] as String, c),
            _receiptRow('Amount', '€${(t['amount'] as double).toStringAsFixed(2)}', c),
            _receiptRow('Status', (t['status'] as String).toUpperCase(), c),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, AppColorScheme c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary)),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: c.textMain)),
      ],
    ),
  );
}

Widget _backBtn(AppColorScheme c, BuildContext context) => GestureDetector(
  onTap: () => Navigator.pop(context),
  child: Container(
    width: 40, height: 40,
    decoration: BoxDecoration(color: c.hover, borderRadius: BorderRadius.circular(20)),
    child: Icon(Icons.arrow_back_ios_new, size: 18, color: c.textMain),
  ),
);

TextStyle _titleStyle(AppColorScheme c) => GoogleFonts.plusJakartaSans(
  fontSize: 18, fontWeight: FontWeight.bold, color: c.textMain, letterSpacing: -0.015,
);
