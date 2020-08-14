import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

const whiteHeaderStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white);
const headerStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
const subHeaderStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700);
const subHeaderMainColorStyle = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w700, color: backgroundColor);

const whiteStyle = TextStyle(color: Colors.white);

const whiteShadowStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  shadows: <Shadow>[
    Shadow(offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.black),
  ],
);

const whiteSmallShadowStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  shadows: <Shadow>[
    Shadow(offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.black),
  ],
);
const redHeaderStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(238, 123, 118, 1));
const blueHeaderStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(78, 161, 158, 1));
