import 'package:flutter/material.dart';

class SoftPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SoftPageRoute({
    required this.page,
  }) : super(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.04, 0.04),
        end: Offset.zero,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}

Future<T?> openSoftPage<T>(
    BuildContext context,
    Widget page,
    ) {
  return Navigator.of(context).push<T>(
    SoftPageRoute<T>(
      page: page,
    ),
  );
}