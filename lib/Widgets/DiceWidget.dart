import 'package:flutter/material.dart';
import 'dart:math';
import '../Model/Responsive.dart';

class DiceWidget extends StatefulWidget {
  final int value;
  final bool isRolling;
  final VoidCallback onTap;
  final double? scale;

  const DiceWidget({
    Key? key,
    required this.value,
    this.isRolling = false,
    required this.onTap,
    this.scale,
  }) : super(key: key);

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = widget.scale ?? responsive.scale;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 60 * scale,
                height: 60 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12 * scale),
                  border: Border.all(color: Colors.blue, width: 3 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
                child: Center(child: _buildDiceFace(widget.value, scale)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiceFace(int value, double scale) {
    switch (value) {
      case 1:
        return _buildDot(0, 0, scale);
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildDot(-1, -1, scale), _buildDot(1, 1, scale)],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildDot(-1, -1, scale), _buildDot(0, 0, scale), _buildDot(1, 1, scale)],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, -1, scale), _buildDot(1, -1, scale)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, 1, scale), _buildDot(1, 1, scale)],
            ),
          ],
        );
      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, -1, scale), _buildDot(1, -1, scale)],
            ),
            _buildDot(0, 0, scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, 1, scale), _buildDot(1, 1, scale)],
            ),
          ],
        );
      case 6:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, -1, scale), _buildDot(1, -1, scale)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, 0, scale), _buildDot(1, 0, scale)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildDot(-1, 1, scale), _buildDot(1, 1, scale)],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDot(double x, double y, double scale) {
    return Transform.translate(
      offset: Offset(x * 8 * scale, y * 8 * scale),
      child: Container(
        width: 8 * scale,
        height: 8 * scale,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


