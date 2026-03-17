import 'package:bullatech/core/enums/transition_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPageTransition {
  static const Duration defaultDuration = Duration(milliseconds: 320);

  static CustomTransitionPage<T> slideRightWithFade<T>({
    required final Widget child,
    final Duration duration = defaultDuration,
  }) {
    return _buildTransition(
      child: child,
      duration: duration,
      type: TransitionType.slideRightWithFade,
    );
  }

  static CustomTransitionPage<T> _buildTransition<T>({
    required final Widget child,
    required final Duration duration,
    required final TransitionType type,
  }) {
    Widget transitionsBuilder(
        final BuildContext context,
        final Animation<double> animation,
        final Animation<double> secondaryAnimation,
        final Widget child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      switch (type) {
        case TransitionType.slideRightWithFade:
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
        case TransitionType.slideLeft:
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                    .animate(curved),
            child: child,
          );
        case TransitionType.fade:
          return FadeTransition(
            opacity: curved,
            child: child,
          );
        default:
          return child;
      }
    }

    return CustomTransitionPage<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      child: child,
      transitionsBuilder: transitionsBuilder,
    );
  }
}
