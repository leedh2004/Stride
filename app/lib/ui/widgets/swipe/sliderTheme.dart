import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

Widget PurpleSliderTheme(BuildContext context, Widget child) {
  return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: backgroundColor,
        inactiveTrackColor: Colors.black12,
        trackHeight: 3.0,
        thumbColor: backgroundColor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0),
        overlayColor: Colors.purple.withAlpha(40),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
      ),
      child: child);
}
