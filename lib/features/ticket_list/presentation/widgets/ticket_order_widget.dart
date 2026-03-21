// delivery_order_sheet.dart
//
// Drop this file into your project and show it from DriverHomeScreen:
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => TicketOrderWidget(order: sampleOrder),
//   );
//
// Dependencies already in your project: flutter_riverpod, google_maps_flutter
// No extra packages required.

import 'dart:async';
import 'package:bullatech/features/ticket_list/presentation/widgets/order_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────

enum PaymentMethod { cod, prepaid, wallet }

class DeliveryStop {
  final String label;
  final String name;
  final String address;
  final String? note;

  const DeliveryStop({
    required this.label,
    required this.name,
    required this.address,
    this.note,
  });
}

class PackageInfo {
  final String description;
  final double weightKg;
  final String size;
  final List<String> tags;

  const PackageInfo({
    required this.description,
    required this.weightKg,
    required this.size,
    this.tags = const [],
  });
}

class CustomerInfo {
  final String name;
  final String phone;
  final String? specialInstruction;

  const CustomerInfo({
    required this.name,
    required this.phone,
    this.specialInstruction,
  });
}

class DeliveryOrder {
  final String orderId;
  final DeliveryStop pickup;
  final DeliveryStop dropoff;
  final PackageInfo package;
  final CustomerInfo customer;
  final double fareAmount;
  final double distanceKm;
  final int estimatedMinutes;
  final PaymentMethod paymentMethod;
  final int expiresInSeconds;

  const DeliveryOrder({
    required this.orderId,
    required this.pickup,
    required this.dropoff,
    required this.package,
    required this.customer,
    required this.fareAmount,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.paymentMethod,
    this.expiresInSeconds = 30,
  });
}

// Sample order for testing
const sampleOrder = DeliveryOrder(
  orderId: 'BT-20481',
  fareAmount: 285,
  distanceKm: 3.2,
  estimatedMinutes: 18,
  paymentMethod: PaymentMethod.cod,
  expiresInSeconds: 30,
  pickup: DeliveryStop(
    label: 'Departure',
    name: '7-Eleven EDSA Kamuning',
    address: 'EDSA cor. Kamuning Rd, Quezon City',
    note: 'Confirm with staff',
  ),
  dropoff: DeliveryStop(
    label: 'Arrival',
    name: 'SM North EDSA, The Annex',
    address: 'North Ave, Quezon City, 1105',
    note: 'Gate 3 — leave with guard',
  ),
  package: PackageInfo(
    description: 'Grocery bundle (3 items)',
    weightKg: 2.1,
    size: 'Medium box',
    tags: ['Fragile', 'Keep upright'],
  ),
  customer: CustomerInfo(
    name: 'Juan Reyes',
    phone: '+63 917 123 4567',
    specialInstruction: 'Please call before dropping off',
  ),
);

// ─────────────────────────────────────────────
// Theme tokens
// ─────────────────────────────────────────────

class _T {
  static const brand = Color(0xFF1A6BFF);
  static const brandLight = Color(0xFFE8F0FF);
  static const brandDark = Color(0xFF0A3FA3);
  static const success = Color(0xFF12A05C);
  static const successLight = Color(0xFFE1F7ED);
  static const amber = Color(0xFFE07C00);
  static const amberLight = Color(0xFFFFF3E0);
  static const surface = Colors.white;
  static const surface2 = Color(0xFFF5F5F7);
  static const border = Color(0xFFE5E5EA);
  static const text = Color(0xFF1C1C1E);
  static const muted = Color(0xFF8E8E93);
  static const hint = Color(0xFFAEAEB2);
  static const tagFragileBg = Color(0xFFFFF3E0);
  static const tagFragileText = Color(0xFFA05800);
  static const tagHeavyBg = Color(0xFFF3E8FF);
  static const tagHeavyText = Color(0xFF6B21A8);
  static const red = Color(0xFFCC3300);
  static const ff = 'SF Pro Display';
}

// ─────────────────────────────────────────────
// Main Sheet
// ─────────────────────────────────────────────

class TicketOrderWidget extends StatefulWidget {
  final DeliveryOrder order;
  final VoidCallback? onAccepted;

  const TicketOrderWidget({
    super.key,
    required this.order,
    this.onAccepted,
  });

  @override
  State<TicketOrderWidget> createState() => _TicketOrderWidgetState();
}

class _TicketOrderWidgetState extends State<TicketOrderWidget>
    with TickerProviderStateMixin {
  // Timer
  late int _remaining;
  Timer? _countdownTimer;

  // Swipe state
  double _swipeFraction = 0.0;

  // Accepted animation
  late AnimationController _acceptedController;

  // Pulse animation for "New order" badge
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Slide-in animation for the whole card
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _remaining = widget.order.expiresInSeconds;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _acceptedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _slideController.forward();
  }

  void _onSwipeUpdate(final DragUpdateDetails d, final double trackWidth) {
    final maxSlide = trackWidth - 56 - 8;
    setState(() {
      _swipeFraction =
          ((_swipeFraction * maxSlide + d.delta.dx) / maxSlide).clamp(0.0, 1.0);
    });
  }

  void _onSwipeEnd(final double trackWidth) {
    if (_swipeFraction >= 0.78) {
      _acceptOrder();
    }
  }

  void _acceptOrder() {
    HapticFeedback.mediumImpact();
    setState(() {
      _swipeFraction = 1.0;
    });
    _countdownTimer?.cancel();

    // Start accepted animation
    Future.delayed(const Duration(milliseconds: 200), () {
      _acceptedController.forward();
      widget.onAccepted?.call();

      // After the accepted animation finishes, slide out card and show success
      _acceptedController.addStatusListener((final status) {
        if (status == AnimationStatus.completed) {
          _slideController.reverse().then((final _) {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (final _, final __, final ___) =>
                    const OrderSuccessDialog(),
                transitionsBuilder:
                    (final _, final animation, final __, final child) {
                  final offsetAnim = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ));
                  return SlideTransition(position: offsetAnim, child: child);
                },
              ),
            );
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    _acceptedController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Container(
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _T.border, width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHandle(),
                _buildHeader(),
                const _Divider(),
                _buildRoute(),
                const SizedBox(height: 12),
                _buildStats(),
                const SizedBox(height: 10),
                _buildPackage(),
                const SizedBox(height: 10),
                _buildCustomer(),
                const _Divider(),
                _buildSwipe(),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 6),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: _T.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (final _, final __) => Opacity(
                opacity: 1.0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _T.brandLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: _pulseAnim.value,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: _T.brand,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'New ticket',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _T.brandDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '#${widget.order.orderId}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Courier',
                color: _T.muted,
              ),
            ),
          ],
        ),
      );

  Widget _buildRoute() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _StopRow(
              stop: widget.order.pickup,
              icon: '📦',
              iconBg: _T.brandLight,
              showLine: true,
              noteBg: _T.brandLight,
              noteText: _T.brandDark,
            ),
            _StopRow(
              stop: widget.order.dropoff,
              icon: '📍',
              iconBg: _T.successLight,
              showLine: false,
              noteBg: _T.successLight,
              noteText: const Color(0xFF0A6640),
            ),
          ],
        ),
      );

  Widget _buildStats() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _StatChip(
              label: 'Distance',
              value: '${widget.order.distanceKm} km',
            ),
            const SizedBox(width: 8),
            _StatChip(
              label: 'Est. time',
              value: '${widget.order.estimatedMinutes} min',
            ),
            const SizedBox(width: 8),
          ],
        ),
      );

  Widget _buildPackage() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _T.surface2,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _T.amberLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Text('📦', style: TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.package.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _T.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '~${widget.order.package.weightKg} kg  ·  ${widget.order.package.size}',
                      style: const TextStyle(fontSize: 12, color: _T.muted),
                    ),
                    if (widget.order.package.tags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: widget.order.package.tags
                            .map((final t) => _Tag(label: t))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCustomer() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: _T.brandLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials(widget.order.customer.name),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _T.brandDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.customer.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _T.text,
                    ),
                  ),
                  if (widget.order.customer.specialInstruction != null)
                    Text(
                      '"${widget.order.customer.specialInstruction}"',
                      style: const TextStyle(fontSize: 12, color: _T.muted),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildSwipe() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (final context, final constraints) {
              final trackWidth = constraints.maxWidth;
              final maxSlide = trackWidth - 56 - 8;
              final thumbOffset =
                  (_swipeFraction * maxSlide).clamp(0.0, maxSlide);

              return GestureDetector(
                onHorizontalDragUpdate: (final d) =>
                    _onSwipeUpdate(d, trackWidth),
                onHorizontalDragEnd: (final _) => _onSwipeEnd(trackWidth),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: _T.brandLight,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Stack(
                    children: [
                      // Fill bar
                      AnimatedContainer(
                        duration: _swipeFraction == 0
                            ? const Duration(milliseconds: 300)
                            : Duration.zero,
                        curve: Curves.easeOutBack,
                        width: thumbOffset + 56,
                        height: 58,
                        decoration: BoxDecoration(
                          color: _T.brand,
                          borderRadius: BorderRadius.circular(29),
                        ),
                      ),
                      // Label
                      Center(
                        child: AnimatedOpacity(
                          opacity: (1 - _swipeFraction * 2.5).clamp(0.0, 1.0),
                          duration: const Duration(milliseconds: 80),
                          child: const Text(
                            'Slide to accept',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _T.brand,
                            ),
                          ),
                        ),
                      ),
                      // Thumb
                      AnimatedPositioned(
                        duration: _swipeFraction == 0
                            ? const Duration(milliseconds: 300)
                            : Duration.zero,
                        curve: Curves.easeOutBack,
                        left: 4 + thumbOffset,
                        top: 5,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _swipeFraction > 0.3 ? '✓' : '→',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Swipe right to accept this order',
            style: TextStyle(fontSize: 12, color: _T.muted),
          ),
        ],
      ),
    );
  }

  String _initials(final String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _StopRow extends StatelessWidget {
  final DeliveryStop stop;
  final String icon;
  final Color iconBg;
  final bool showLine;
  final Color noteBg;
  final Color noteText;

  const _StopRow({
    required this.stop,
    required this.icon,
    required this.iconBg,
    required this.showLine,
    required this.noteBg,
    required this.noteText,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 15))),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 46,
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: CustomPaint(painter: _DashedLinePainter()),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: _T.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stop.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _T.text,
                  ),
                ),
                Text(
                  stop.address,
                  style: const TextStyle(fontSize: 12, color: _T.muted),
                ),
                if (stop.note != null) ...[
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: noteBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      stop.note!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: noteText,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(final BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: _T.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: _T.muted)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
        ),
      );
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(final BuildContext context) {
    final isFragile = label.toLowerCase() == 'fragile';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isFragile ? _T.tagFragileBg : _T.tagHeavyBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isFragile ? _T.tagFragileText : _T.tagHeavyText,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(final BuildContext context) =>
      Container(height: 0.5, color: _T.border);
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(final Canvas canvas, final Size size) {
    const dashH = 5.0;
    const gapH = 4.0;
    final paint = Paint()
      ..color = _T.border
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var y = 0.0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(final _) => false;
}
