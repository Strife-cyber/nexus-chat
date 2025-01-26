import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AnimatedCircleAvatar extends StatefulWidget {
  final double radius;
  final Color initialBorderColor;
  final Color activeBorderColor;
  final double borderWidth;
  final void Function(Uint8List? imageBytes)? onImagePicked;
  final Uint8List? initialProfile;

  const AnimatedCircleAvatar({
    super.key,
    this.radius = 50,
    this.initialBorderColor = Colors.purple,
    this.activeBorderColor = Colors.deepPurple,
    this.borderWidth = 2.0,
    this.onImagePicked,
    this.initialProfile,
  });

  @override
  State<AnimatedCircleAvatar> createState() => _AnimatedCircleAvatarState();
}

class _AnimatedCircleAvatarState extends State<AnimatedCircleAvatar>
    with SingleTickerProviderStateMixin {
  Uint8List? _imageBytes;

  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();

    _imageBytes = widget.initialProfile;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _borderColorAnimation = ColorTween(
      begin: widget.initialBorderColor,
      end: widget.activeBorderColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedCircleAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the avatar image when `initialProfile` changes
    if (oldWidget.initialProfile != widget.initialProfile) {
      setState(() {
        _imageBytes = widget.initialProfile;
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      final bytes = result.files.single.bytes;

      setState(() {
        _imageBytes = bytes;
      });

      // Notify the parent widget about the image selection
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(bytes);
      }

      // Animate the border color change
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _borderColorAnimation.value!,
                width: widget.borderWidth,
              ),
            ),
            child: CircleAvatar(
              radius: widget.radius,
              backgroundColor: Colors.white,
              backgroundImage:
                  _imageBytes != null ? MemoryImage(_imageBytes!) : null,
              child: _imageBytes == null
                  ? ScaleTransition(
                      scale: _iconScaleAnimation,
                      child: Icon(
                        Icons.camera_alt,
                        color: widget.initialBorderColor,
                        size: widget.radius * 0.6,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
