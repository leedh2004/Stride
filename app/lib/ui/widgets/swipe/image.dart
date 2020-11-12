import 'package:flutter/material.dart';

Widget heartImageWidget() {
  return Container(
    padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
    alignment: Alignment.center,
    child: Image.asset(
      'assets/swipe_heart.png',
      width: 100,
    ),
  );
}

Widget dislikeImageWidget() {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
    alignment: Alignment.center,
    child: Image.asset(
      'assets/swipe_dislike.png',
      width: 100,
    ),
  );
}
