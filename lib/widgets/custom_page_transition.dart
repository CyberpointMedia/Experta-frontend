import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A custom page transition that slides the new page in from the right.
class CustomPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Ensure the curve is not null, defaulting to Curves.linear if it is.
    final effectiveCurve = curve ?? Curves.linear;

    // Create a tween for the slide transition.
    final offsetTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    // Animate the tween with the provided animation and curve.
    final slideAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animation,
        curve: effectiveCurve,
      ),
    );

    // Return the SlideTransition widget.
    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}
