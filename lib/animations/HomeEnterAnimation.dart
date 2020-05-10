import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/widgets.dart';

class HomeEnterAnimation {
  final AnimationController controller;
  final Animation<double> imageWidth;
  final Animation<double> listOpacity;

  HomeEnterAnimation(this.controller)
      : imageWidth = new Tween(begin: 1.0, end: 130.0).animate(
            new CurvedAnimation(
                parent: controller,
                curve: new Interval(0.30, 0.80, curve: Curves.easeInOutCirc))),
        listOpacity = new Tween(begin: 0.0, end: 1.0).animate(
            new CurvedAnimation(
                parent: controller,
                curve: new Interval(0.70, 1.0, curve: Curves.easeInOut)));
}
