import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBall(0),
            SizedBox(width: 20),
            _buildBall(1),
            SizedBox(width: 20),
            _buildBall(2),
          ],
        );
      },
    );
  }

  Widget _buildBall(int index) {
    double top = 0.0;
    if (index == 0) {
      top = -30 * _controller.value + 30;
    } else if (index == 1) {
      top = 30 * _controller.value;
    } else if (index == 2) {
      top = -30 * _controller.value + 30;
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppTheme.theme.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(top: top),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}