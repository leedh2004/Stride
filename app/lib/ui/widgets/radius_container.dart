import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class RadiusContainer extends StatelessWidget {
  final Widget child;

  RadiusContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        gradient: RadialGradient(
            colors: [backgroundColor, Colors.white],
            radius: 1.0,
            stops: [0.1, 0.75]),

        //center: Alignment.center,
        //stops: [0.4, 1.0]),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
