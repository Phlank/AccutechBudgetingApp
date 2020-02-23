import 'package:flutter/material.dart';

class RouteUtil {
  static routeWithSlideTransition(Widget target) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}
