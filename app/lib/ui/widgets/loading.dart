import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

Widget LoadingWidget() {
  return Center(
    child: Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Image.asset(
          //   'images/a.png',
          //   width: 48,
          // ),
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
              spinnerMode: true,
              customColors: CustomSliderColors(progressBarColors: [
                gradientStart,
                backgroundColor,
              ]),
            ),
          )
        ],
      ),
    ),
  );
}
