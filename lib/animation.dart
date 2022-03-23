import 'dart:async';

import 'package:flutter/material.dart';

class DelayedDisplay extends StatefulWidget {
  const DelayedDisplay({
    Key? key,
    this.padding,
    required this.child,
    this.delay = Duration.zero,
    this.fadingDuration = const Duration(milliseconds: 800),
    this.slidingCurve = Curves.decelerate,
    this.slidingBeginOffset = const Offset(0.0, 0.10),
    this.fadeIn = true,
  }) : super(key: key);

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final Duration delay;

  final Duration fadingDuration;

  final Curve slidingCurve;

  final Offset slidingBeginOffset;

  final bool fadeIn;

  @override
  State<DelayedDisplay> createState() => _DelayedDisplayState();
}

class _DelayedDisplayState extends State<DelayedDisplay>
    with TickerProviderStateMixin {
  late AnimationController opacityController;

  late Animation<Offset> slideAnimationOffset;

  Timer? timer;

  Duration get delay => widget.delay;

  Duration get opacityTransitionDuration => widget.fadingDuration;

  Curve get slidingCurve => widget.slidingCurve;

  Offset get beginOffset => widget.slidingBeginOffset;

  bool get fadeIn => widget.fadeIn;

  @override
  void initState() {
    super.initState();

    opacityController = AnimationController(
      vsync: this,
      duration: opacityTransitionDuration,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: opacityController,
      curve: slidingCurve,
    );

    slideAnimationOffset = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(curvedAnimation);

    runFadeAnimation();
  }

  void runFadeAnimation() {
    timer = Timer(delay, () {
      fadeIn ? opacityController.forward() : opacityController.reverse();
    });
  }

  @override
  void didUpdateWidget(covariant DelayedDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fadeIn == fadeIn) {
      return;
    }

    runFadeAnimation();
  }

  @override
  void dispose() {
    opacityController.dispose();
    timer?.cancel();

    timer = null;

    super.dispose();
  }

  Widget isPaddingnotNull() {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(1.0),
      child: SlideTransition(
        position: slideAnimationOffset,
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.padding == null) {
      return SlideTransition(
        position: slideAnimationOffset,
        child: widget.child,
      );
    } else {
      return isPaddingnotNull();
    }
  }
}

/// Custom pushNewScreen
void pushNewScreen(BuildContext context, Widget page) {
  Navigator.push(context, _createRoute(page));
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(microseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ),
        ),
        child: child,
      );
    },
  );
}
