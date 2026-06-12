import 'package:flutter/material.dart';

import '../theme.dart';

/// Fades + slides its child up into place after `index * 50ms`, giving lists
/// and form stacks the staggered entrance the design directive requires.
/// Give consecutive siblings consecutive indices.
class StaggerIn extends StatefulWidget {
  const StaggerIn({
    super.key,
    required this.index,
    required this.child,
    this.offset = 12,
  });

  final int index;
  final double offset;
  final Widget child;

  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.entrance,
  );
  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.curve,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(AppMotion.staggerStep * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - _animation.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
