import 'package:flutter/material.dart';

class CustomRippleEffect extends StatefulWidget {
  const CustomRippleEffect({
    Key? key, // add this line
    required this.child,
    required this.onClick,
  }) : super(key: key); // and change this line

  final Widget child;
  final Function onClick;

  @override
  State<CustomRippleEffect> createState() => _CustomRippleEffectState();
}

class _CustomRippleEffectState extends State<CustomRippleEffect>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scaleAnimation;
  late final Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    colorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0),
      end: Colors.white.withOpacity(0.3),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        controller.forward();
      },
      onTapUp: (TapUpDetails details) {
        widget.onClick();
        Future.delayed(const Duration(milliseconds: 100), () {
          controller.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: colorAnimation.value,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: widget
                  .child, // You also need to change this line to widget.child
            ),
          );
        },
      ),
    );
  }
}
