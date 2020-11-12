import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class PurpleCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
    );
  }
}
