import 'package:flutter/material.dart';

class RadiusContainer extends StatelessWidget {
  final Widget child;

  RadiusContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      child: child,
    );
  }
}
