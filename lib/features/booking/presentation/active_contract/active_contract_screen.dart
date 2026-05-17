import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/utils/currency_formatter.dart';
import 'package:pfe/core/models/property_model.dart';
import 'package:intl/intl.dart';

class ActiveContractScreen extends StatelessWidget {
  final Map<String, dynamic> booking;
  final PropertyModel? property;

  const ActiveContractScreen({
    super.key,
    required this.booking,
    this.property,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    // Parse dates
    DateTime? moveIn;
    DateTime? moveOut;
    try {
      moveIn = DateTime.parse(booking['moveInDate']?.toString() ?? '');
    } catch (_) {}
    try {
      moveOut = DateTime.parse(booking['moveOutDate']?.toString() ?? '');
    } catch (_) {}

    final now = DateTime.now();
    final isActive = moveIn != null && now.isAfter(moveIn);
    final isEnded = moveOut != null && now.isAfter(moveOut);

    Duration? timeToStart;
    Duration? timeToEnd;
    if (moveIn != null && !isActive) timeToStart = moveIn.difference(now);
    if (moveOut != null && isActive && !isEnded) timeToEnd = moveOut.difference(now);

    final nights = (moveIn != null && moveOut != null)
        ? moveOut.difference(moveIn).inDays
        : 0;

    final totalPrice = (booking['totalPrice'] as num?) ?? 0;
    final imageUrl = property?.images.isNotEmpty == true
        ? property!.images.first
        : 'https://placehold.co/400x400/png';

    // Contract state
    ContractState contractState;
    if (isEnded) {
      contractState = ContractState.ended;
    } else if (isActive) {
      contractState = ContractState.active;
    } else {
      contractState = ContractState.upcoming;
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              color: c.card,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: c.hover,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18, color: c.textMain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your Contract',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Status Badge ────────────────────────────────────────
                    _StatusBanner(state: contractState, c: c),
                    const SizedBox(height: 20),

                    // ── Countdown Card ──────────────────────────────────────
                    if (contractState == ContractState.upcoming && timeToStart != null)
                      _CountdownCard(
                        label: 'Move-in starts in',
                        duration: timeToStart,
                        targetDate: moveIn!,
                        icon: Icons.key_rounded,
                        color: const Color(0xFF136DEC),
                        c: c,
                      ),
                    if (contractState == ContractState.active && timeToEnd != null)
                      _CountdownCard(
                        label: 'Contract ends in',
                        duration: timeToEnd,
                        targetDate: moveOut!,
                        icon: Icons.timelapse_rounded,
                        color: Colors.green,
                        c: c,
                      ),
                    if (contractState == ContractState.ended)
                      _EndedCard(c: c),
                    const SizedBox(height: 20),

                    // ── Property Card ───────────────────────────────────────
                    Text(
                      'Property',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100, height: 100, color: c.statsBg,
                                child: Icon(Icons.home, color: c.textSecondary, size: 36),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property?.title ?? 'Property',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15, fontWeight: FontWeight.bold, color: c.textMain,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    property?.subtitle ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13, color: c.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Contract Details ────────────────────────────────────
                    Text(
                      'Contract Details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: c.border),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Icons.login_rounded,
                            label: 'Move-in Date',
                            value: moveIn != null
                                ? DateFormat('EEEE, dd MMM yyyy').format(moveIn)
                                : '—',
                            c: c,
                          ),
                          _divider(c),
                          _DetailRow(
                            icon: Icons.logout_rounded,
                            label: 'Move-out Date',
                            value: moveOut != null
                                ? DateFormat('EEEE, dd MMM yyyy').format(moveOut)
                                : '—',
                            c: c,
                          ),
                          _divider(c),
                          _DetailRow(
                            icon: Icons.nights_stay_rounded,
                            label: 'Duration',
                            value: '$nights night${nights == 1 ? '' : 's'}',
                            c: c,
                          ),
                          _divider(c),
                          _DetailRow(
                            icon: Icons.confirmation_number_rounded,
                            label: 'Booking ID',
                            value: (booking['id'] as String? ?? '—').length > 10
                                ? '${(booking['id'] as String).substring(0, 10)}…'
                                : (booking['id'] as String? ?? '—'),
                            c: c,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Payment Summary ─────────────────────────────────────
                    Text(
                      'Payment Summary',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, fontWeight: FontWeight.bold, color: c.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<String>(
                      valueListenable: CurrencyFormatter.symbolNotifier,
                      builder: (context, _, __) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: c.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: c.border),
                          ),
                          child: Column(
                            children: [
                              _PaymentRow(
                                label: '${property?.displayPrice ?? '—'} × $nights nights',
                                value: CurrencyFormatter.format(totalPrice),
                                c: c,
                              ),
                              _divider(c),
                              _PaymentRow(
                                label: 'Total Paid',
                                value: CurrencyFormatter.format(totalPrice),
                                isBold: true,
                                c: c,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ── Contract Status Info ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: c.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              contractState == ContractState.active
                                  ? 'Your contract is currently active. Enjoy your stay!'
                                  : contractState == ContractState.upcoming
                                      ? 'Your booking is confirmed. You will be notified when your move-in date approaches.'
                                      : 'This contract has ended. Thank you for using our service!',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: c.primary,
                                height: 1.4,
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
      ),
    );
  }

  Widget _divider(AppColorScheme c) => Divider(color: c.border, height: 20);
}

// ── Contract State ────────────────────────────────────────────────────────────
enum ContractState { upcoming, active, ended }

// ── Status Banner ─────────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final ContractState state;
  final AppColorScheme c;
  const _StatusBanner({required this.state, required this.c});

  @override
  Widget build(BuildContext context) {
    final (label, icon, bg, fg) = switch (state) {
      ContractState.active  => ('Contract Active', Icons.check_circle_rounded, Colors.green.shade50, Colors.green.shade700),
      ContractState.upcoming => ('Contract Confirmed — Upcoming', Icons.schedule_rounded, const Color(0xFFEFF6FF), const Color(0xFF136DEC)),
      ContractState.ended   => ('Contract Ended', Icons.done_all_rounded, Colors.grey.shade100, Colors.grey.shade700),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 28),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Countdown Card ────────────────────────────────────────────────────────────
class _CountdownCard extends StatelessWidget {
  final String label;
  final Duration duration;
  final DateTime targetDate;
  final IconData icon;
  final Color color;
  final AppColorScheme c;
  const _CountdownCard({
    required this.label, required this.duration, required this.targetDate,
    required this.icon, required this.color, required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final mins = duration.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14, fontWeight: FontWeight.w600, color: color,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM yyyy').format(targetDate),
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: color.withValues(alpha: 0.8)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TimeUnit(value: '$days', label: 'days', color: color),
              _timeSep(color),
              _TimeUnit(value: '${hours.toString().padLeft(2, '0')}', label: 'hours', color: color),
              _timeSep(color),
              _TimeUnit(value: '${mins.toString().padLeft(2, '0')}', label: 'min', color: color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeSep(Color color) =>
      Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color));
}

class _TimeUnit extends StatelessWidget {
  final String value, label;
  final Color color;
  const _TimeUnit({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28, fontWeight: FontWeight.bold, color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: color.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

// ── Ended Card ────────────────────────────────────────────────────────────────
class _EndedCard extends StatelessWidget {
  final AppColorScheme c;
  const _EndedCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.statsBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: c.textSecondary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This stay has been completed.',
              style: GoogleFonts.plusJakartaSans(fontSize: 14, color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final AppColorScheme c;
  const _DetailRow({required this.icon, required this.label, required this.value, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: c.statsBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: c.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: c.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: c.textMain)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Payment Row ───────────────────────────────────────────────────────────────
class _PaymentRow extends StatelessWidget {
  final String label, value;
  final bool isBold;
  final AppColorScheme c;
  const _PaymentRow({required this.label, required this.value, this.isBold = false, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: isBold ? 15 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? c.textMain : c.textSecondary)),
        Text(value,
            style: GoogleFonts.plusJakartaSans(
                fontSize: isBold ? 15 : 14,
                fontWeight: FontWeight.bold,
                color: isBold ? c.primary : c.textMain)),
      ],
    );
  }
}
