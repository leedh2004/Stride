import 'dart:ui';

import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class BoolWrapper {
  bool value;
  BoolWrapper(bool _value) {
    value = _value;
  }
}

class ColorFilter extends StatefulWidget {
  SwipeModel model;
  ColorFilter(this.model);
  @override
  _ColorFilterState createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  BoolWrapper all;
  BoolWrapper red;
  BoolWrapper black;
  BoolWrapper white;
  BoolWrapper gray;
  BoolWrapper brown;
  BoolWrapper beige;
  BoolWrapper navy;
  BoolWrapper blue;
  BoolWrapper green;
  BoolWrapper ivory;
  BoolWrapper pink;
  BoolWrapper yellow;
  BoolWrapper orange;
  BoolWrapper purple;

  Widget unSelectedWidget(Color color, BoolWrapper type, String title) {
    bool blackBorder = false;
    if (['상관없음', '화이트', '아이보리'].contains(title)) blackBorder = true;
    return InkWell(
      onTap: () {
        if (identical(type, all)) {
          red.value = black.value = white.value = gray.value = brown.value =
              beige.value = navy.value = blue.value = green.value =
                  ivory.value = pink.value =
                      yellow.value = orange.value = purple.value = false;
        } else if (all.value == true) {
          all.value = false;
        }
        type.value = true;
        List<String> colors = new List();
        all.value ? colors.add('all') : null;
        red.value ? colors.add('red') : null;
        black.value ? colors.add('black') : null;
        white.value ? colors.add('white') : null;
        gray.value ? colors.add('gray') : null;
        brown.value ? colors.add('brown') : null;
        beige.value ? colors.add('beige') : null;
        navy.value ? colors.add('navy') : null;
        blue.value ? colors.add('blue') : null;
        green.value ? colors.add('green') : null;
        ivory.value ? colors.add('ivory') : null;
        pink.value ? colors.add('pink') : null;
        yellow.value ? colors.add('yellow') : null;
        orange.value ? colors.add('orange') : null;
        purple.value ? colors.add('purple') : null;
        widget.model.setColors(colors);
        setState(() {});
      },
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 6, right: 6, bottom: 8),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: blackBorder
                ? Border.all(color: Colors.black12)
                : Border.all(color: Colors.transparent),
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10),
        ),
        SizedBox(
          height: 24,
        )
      ]),
    );
  }

  Widget selectedWidget(Color color, BoolWrapper type, String title) {
    bool blackCheck = false;
    bool blackBorder = false;
    if (['상관없음', '화이트', '베이지', '아이보리', '옐로우'].contains(title))
      blackCheck = true;
    if (['상관없음', '화이트', '아이보리'].contains(title)) blackBorder = true;
    return InkWell(
      onTap: () {
        type.value = false;
        if (!(all.value ||
            black.value ||
            white.value ||
            gray.value ||
            brown.value ||
            beige.value ||
            navy.value ||
            blue.value ||
            green.value ||
            ivory.value ||
            pink.value ||
            yellow.value ||
            orange.value ||
            purple.value ||
            red.value)) all.value = true;
        List<String> colors = new List();
        all.value ? colors.add('all') : null;
        red.value ? colors.add('red') : null;
        black.value ? colors.add('black') : null;
        white.value ? colors.add('white') : null;
        gray.value ? colors.add('gray') : null;
        brown.value ? colors.add('brown') : null;
        beige.value ? colors.add('beige') : null;
        navy.value ? colors.add('navy') : null;
        blue.value ? colors.add('blue') : null;
        green.value ? colors.add('green') : null;
        ivory.value ? colors.add('ivory') : null;
        pink.value ? colors.add('pink') : null;
        yellow.value ? colors.add('yellow') : null;
        orange.value ? colors.add('orange') : null;
        purple.value ? colors.add('purple') : null;
        widget.model.setColors(colors);
        setState(() {});
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          margin: EdgeInsets.only(left: 6, right: 6, bottom: 8),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: blackBorder
                ? Border.all(color: Colors.black12)
                : Border.all(color: Colors.transparent),
            color: color,
          ),
          child: Icon(
            Icons.check,
            color: blackCheck ? Colors.black : Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8569EF)),
        ),
        SizedBox(
          height: 24,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    all = BoolWrapper(widget.model.filter.colors.contains('all'));
    black = BoolWrapper(widget.model.filter.colors.contains('black'));
    white = BoolWrapper(widget.model.filter.colors.contains('white'));
    gray = BoolWrapper(widget.model.filter.colors.contains('gray'));
    brown = BoolWrapper(widget.model.filter.colors.contains('brown'));
    beige = BoolWrapper(widget.model.filter.colors.contains('beige'));
    navy = BoolWrapper(widget.model.filter.colors.contains('navy'));
    blue = BoolWrapper(widget.model.filter.colors.contains('blue'));
    green = BoolWrapper(widget.model.filter.colors.contains('green'));
    ivory = BoolWrapper(widget.model.filter.colors.contains('ivory'));
    pink = BoolWrapper(widget.model.filter.colors.contains('pink'));
    yellow = BoolWrapper(widget.model.filter.colors.contains('yellow'));
    orange = BoolWrapper(widget.model.filter.colors.contains('orange'));
    purple = BoolWrapper(widget.model.filter.colors.contains('purple'));
    red = BoolWrapper(widget.model.filter.colors.contains('red'));

    Map<Color, BoolWrapper> types = {
      Color.fromRGBO(255, 255, 255, 0.9): all,
      Color.fromRGBO(0, 0, 0, 1): black,
      Color.fromRGBO(255, 255, 255, 1): white,
      Color.fromRGBO(80, 80, 80, 1): gray,
      Color.fromRGBO(93, 69, 40, 1): brown,
      Color.fromRGBO(249, 228, 183, 1): beige,
      Color.fromRGBO(0, 16, 116, 1): navy,
      Color.fromRGBO(0, 64, 255, 1): blue,
      Color.fromRGBO(11, 102, 35, 1): green,
      Color.fromRGBO(255, 255, 240, 1): ivory,
      Color.fromRGBO(231, 84, 128, 1): pink,
      Color.fromRGBO(247, 240, 129, 1): yellow,
      Color.fromRGBO(253, 106, 2, 1): orange,
      Color.fromRGBO(107, 65, 174, 1): purple,
      Color.fromRGBO(228, 52, 35, 1): red
    };

    List<String> colors = [
      '상관없음',
      '블랙',
      '화이트',
      '그레이',
      '브라운',
      '베이지',
      '네이비',
      '블루',
      '그린',
      '아이보리',
      '핑크',
      '옐로우',
      '오렌지',
      '퍼플',
      '레드'
    ];

    List<Color> keys = types.keys.toList();
    List<BoolWrapper> values = types.values.toList();
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
              children: List.generate(
                  keys.length,
                  (index) => values[index].value
                      ? selectedWidget(
                          keys[index], values[index], colors[index])
                      : unSelectedWidget(
                          keys[index], values[index], colors[index]))),
        ]);
  }
}
