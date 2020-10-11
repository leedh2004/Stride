import 'package:flutter/material.dart';

Map<String, Color> colors = {
  'all': Color.fromRGBO(255, 255, 255, 0.9),
  'black': Color.fromRGBO(0, 0, 0, 1),
  'white': Color.fromRGBO(255, 255, 255, 1),
  'gray': Color.fromRGBO(80, 80, 80, 1),
  'brown': Color.fromRGBO(93, 69, 40, 1),
  'beige': Color.fromRGBO(249, 228, 183, 1),
  'navy': Color.fromRGBO(0, 16, 116, 1),
  'blue': Color.fromRGBO(0, 64, 255, 1),
  'green': Color.fromRGBO(11, 102, 35, 1),
  'ivory': Color.fromRGBO(255, 255, 240, 1),
  'pink': Color.fromRGBO(231, 84, 128, 1),
  'yellow': Color.fromRGBO(247, 240, 129, 1),
  'orange': Color.fromRGBO(253, 106, 2, 1),
  'purple': Color.fromRGBO(107, 65, 174, 1),
  'red': Color.fromRGBO(228, 52, 35, 1)
};

class CircleColorWidget extends StatelessWidget {
  final dynamic color;
  CircleColorWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return color == 'white' || color == 'ivory'
        ? Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
                color: colors[color]),
          )
        : Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: colors[color]),
          );
  }
}
