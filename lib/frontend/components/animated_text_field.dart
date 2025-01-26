import 'package:flutter/material.dart';

class AnimatedTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final void Function(String value)? onChange;
  final TextEditingController controller;

  // Customizable fields
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final Color textColor;
  final Color labelColor;
  final Color iconColor;
  final double borderRadius;

  const AnimatedTextField({
    super.key,
    required this.label,
    required this.icon,
    this.onChange,
    required this.obscureText,
    required this.controller,
    this.borderColor = Colors.black12,
    this.focusedBorderColor = Colors.black54,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.labelColor = Colors.black38,
    this.iconColor = Colors.black38,
    this.borderRadius = 12.0,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Define the fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            onChanged: widget.onChange,
            style: TextStyle(
              color: widget.textColor,
              fontFamily: 'montaga',
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: widget.labelColor,
                fontFamily: 'pacifico',
              ),
              prefixIcon: Icon(
                widget.icon,
                color: widget.iconColor,
              ),
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: widget.focusedBorderColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
