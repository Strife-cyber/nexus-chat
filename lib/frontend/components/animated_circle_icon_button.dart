import 'package:flutter/material.dart';

class AnimatedCircleIconButton extends StatefulWidget {
  final double radius; // Changed from int to double for flexibility
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color backgroundColor;

  const AnimatedCircleIconButton({
    super.key,
    required this.radius,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.purpleAccent,
  });

  @override
  State<AnimatedCircleIconButton> createState() =>
      _AnimatedCircleIconButtonState();
}

class _AnimatedCircleIconButtonState extends State<AnimatedCircleIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward(); // Start the animation when pressed
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse(); // Return to normal size when released
  }

  void _onTapCancel() {
    _controller.reverse(); // Handle cancel (e.g., finger dragged out)
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: widget.radius,
                color: widget.iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
