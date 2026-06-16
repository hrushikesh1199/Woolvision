// lib/widgets/neon_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Gradient gradient;
  final Color glowColor;
  final IconData? icon;
  final bool outlined;

  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.gradient,
    required this.glowColor,
    this.icon,
    this.outlined = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _pressed = true);
    _controller.forward();
  }

  void _onTapUp(_) {
    setState(() => _pressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: widget.outlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.glowColor.withOpacity(0.6),
                    width: 1.5,
                  ),
                  boxShadow: _pressed
                      ? [
                          BoxShadow(
                            color: widget.glowColor.withOpacity(0.3),
                            blurRadius: 15,
                          )
                        ]
                      : [],
                )
              : BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor
                          .withOpacity(_pressed ? 0.6 : 0.35),
                      blurRadius: _pressed ? 25 : 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  color: widget.outlined
                      ? widget.glowColor
                      : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
