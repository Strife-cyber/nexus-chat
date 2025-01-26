import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String displayText;

  // Customizable fields
  final Color buttonColor;
  final Color shadowColor;
  final double borderRadius;
  final double fontSize;
  final double width;
  final double heigth;
  final Color textColor;
  final FontWeight fontWeight;
  final String fontFamily;
  final EdgeInsetsGeometry padding;
  final int seconds;

  const AnimatedButton(
      {super.key,
      required this.onPressed,
      required this.displayText,
      this.buttonColor = Colors.purpleAccent,
      this.shadowColor = Colors.blueAccent,
      this.borderRadius = 12.0,
      this.fontSize = 18.0,
      this.width = 200,
      this.heigth = 60,
      this.textColor = Colors.white,
      this.fontWeight = FontWeight.bold,
      this.fontFamily = 'Pacifico',
      this.padding = const EdgeInsets.symmetric(vertical: 15),
      this.seconds = 10});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: widget.padding,
          width: widget.width,
          height: widget.heigth,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.displayText,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: widget.textColor,
                fontFamily: widget.fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
