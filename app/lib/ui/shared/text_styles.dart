import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

const TutorialheaderStyle = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, color: backgroundColor);

const TutorialSubHeaderStyle = TextStyle(fontSize: 18.0, color: Colors.black54);

const dressRoomProductText = TextStyle(fontSize: 11);
const dressRoomPriceText =
    TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black87);
const lookBookNameText =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87);

const whiteHeaderStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white);
const headerStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black);
const subHeaderStyle = TextStyle(fontSize: 18.0, color: Colors.black);
const dressRoomsubHeaderStyle =
    TextStyle(fontSize: 16.0, color: Colors.black54);

const subHeaderMainColorStyle = TextStyle(
  fontSize: 19.0,
  fontWeight: FontWeight.w700,
  color: backgroundColor,
);
const whiteStyle = TextStyle(color: Colors.white);

const whiteShadowStyle =
    TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700);

const whiteSmallShadowStyle =
    TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700);
const redHeaderStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(238, 123, 118, 1));
const greenHeaderStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: greenColor);
const blueHeaderStyle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(78, 161, 158, 1));

const inputPurpleStyle = TextStyle(
    color: backgroundColor, fontSize: 24, fontWeight: FontWeight.w700);

String priceText(int price) {
  // String ret = str.substring(0, str.length - 3) +
  //     ',' +
  //     str.substring(str.length - 3, str.length);
  String str = price.toString();
  String ret = "";
  int idx = str.length - 1;
  int cnt = 0;
  //24000
  for (int i = idx; i >= 0; i--) {
    ret = str[i] + ret;
    cnt++;
    if (cnt % 3 == 0 && i != 0) {
      ret = ',' + ret;
    }
  }
  return ret;
}
