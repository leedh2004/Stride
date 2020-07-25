import 'package:flutter/material.dart';

const whiteHeaderStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white);
const headerStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
const subHeaderStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700);
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
