import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

Widget PurpleSliderTheme(BuildContext context, Widget child) {
  return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          activeTrackColor: Color(0xFF8569EF),
          inactiveTrackColor: Color(0xFFF4F4FC),
          trackHeight: 4.0,
          thumbColor: Color(0xFF8569EF),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
          overlayColor: Colors.purple.withAlpha(40),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
          disabledActiveTrackColor: Color(0xFF888C93),
          disabledThumbColor: Color(0xFF888C93),
          disabledInactiveTrackColor: Color(0xFFF4F4FC)),
      child: child);
}
