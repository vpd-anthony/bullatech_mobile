import 'dart:async';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/ticket_order_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/order_success_dialog.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/stat_chip_widget.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/stop_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TicketOrderWidget extends StatefulWidget {
  final TicketOrder order;
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
  double _swipeFraction = 0.0;

  late AnimationController _acceptedController;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

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

    Future.delayed(const Duration(milliseconds: 200), () {
      _acceptedController.forward();
      widget.onAccepted?.call();

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
    _pulseController.dispose();
    _acceptedController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHandle(),
                _buildHeader(),
                const _Divider(),
                const SizedBox(height: 12),
                _buildRoute(),
                const SizedBox(height: 12),
                _buildStats(),
                const SizedBox(height: 12),
                _buildCustomer(),
                const SizedBox(height: 12),
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
            color: AppColors.border,
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
                    color: AppColors.info,
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
                            color: AppColors.highlightInfo,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'New ticket order',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '#${widget.order.ticketNo}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Courier',
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      );

  Widget _buildRoute() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            StopRow(
              stop: widget.order.departure,
              icon: Icons.local_shipping,
              iconBg: AppColors.info,
              showLine: true,
              noteBg: AppColors.info,
              noteText: AppColors.textWhite,
            ),
            StopRow(
              stop: widget.order.arrival,
              icon: Icons.location_on,
              iconBg: AppColors.successGradient.colors[0],
              showLine: false,
              noteBg: AppColors.successGradient.colors[0],
              noteText: AppColors.textWhite,
            ),
          ],
        ),
      );

  Widget _buildStats() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            StatChip(
              label: 'Distance',
              value: widget.order.distanceKm,
            ),
            const SizedBox(width: 8),
            StatChip(
              label: 'Est. time',
              value: widget.order.estimatedMinutes,
            ),
            const SizedBox(width: 8),
          ],
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
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials(widget.order.customer.name),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.order.customer.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone,
                  size: 16,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.order.customer.phone,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
              ],
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
                    color: AppColors.info,
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
                          color: AppColors.highlightInfo,
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
                              color: AppColors.textWhite,
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
                            color: AppColors.backgroundWhite,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withOpacity(0.12),
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
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(final BuildContext context) =>
      Container(height: 0.5, color: AppColors.border);
}
