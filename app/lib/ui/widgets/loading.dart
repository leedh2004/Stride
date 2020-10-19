import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

Widget LoadingWidget() {
  return Center(
    child: Loading(
      indicator: BallScaleMultipleIndicator(),
      size: 100.0,
      color: backgroundColor,
    ),
  );
}

Widget WhiteLoadingWidget() {
  return Center(
      child: Loading(
    indicator: BallScaleMultipleIndicator(),
    size: 100.0,
    color: Colors.white,
  ));
}
