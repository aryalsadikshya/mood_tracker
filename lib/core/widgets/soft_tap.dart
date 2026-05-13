import 'package:flutter/material.dart';

class SoftTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final BorderRadius? borderRadius;

  const SoftTap({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.97,
    this.borderRadius,
  });

  @override
  State<SoftTap> createState() => _SoftTapState();
}

class _SoftTapState extends State<SoftTap> {
  bool isPressed = false;

  void setPressed(bool value) {
    if (!mounted) return;

    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? widget.pressedScale : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
          onTap: widget.onTap,
          onTapDown: (_) => setPressed(true),
          onTapUp: (_) => setPressed(false),
          onTapCancel: () => setPressed(false),
          child: widget.child,
        ),
      ),
    );
  }
}