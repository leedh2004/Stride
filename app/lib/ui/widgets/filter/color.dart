import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class BoolWrapper {
  bool value;
  BoolWrapper(bool _value) {
    value = _value;
  }
}

class ColorFilter extends StatefulWidget {
  @override
  _ColorFilterState createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  BoolWrapper all = BoolWrapper(true);
  BoolWrapper red = BoolWrapper(false);
  BoolWrapper black = BoolWrapper(false);
  BoolWrapper white = BoolWrapper(false);
  BoolWrapper gray = BoolWrapper(false);
  BoolWrapper brown = BoolWrapper(false);
  BoolWrapper beige = BoolWrapper(false);
  BoolWrapper navy = BoolWrapper(false);
  BoolWrapper blue = BoolWrapper(false);
  BoolWrapper green = BoolWrapper(false);
  BoolWrapper ivory = BoolWrapper(false);
  BoolWrapper pink = BoolWrapper(false);
  BoolWrapper yellow = BoolWrapper(false);
  BoolWrapper orange = BoolWrapper(false);
  BoolWrapper purple = BoolWrapper(false);

  Widget unSelectedWidget(Color color, BoolWrapper type, String title) {
    bool blackBorder = false;
    if (['상관없음', '화이트', '아이보리'].contains(title)) blackBorder = true;
    return InkWell(
      onTap: () {
        setState(() {
          if (identical(type, all)) {
            red.value = black.value = white.value = gray.value = brown.value =
                beige.value = navy.value = blue.value = green.value =
                    ivory.value = pink.value =
                        yellow.value = orange.value = purple.value = false;
          } else if (all.value == true) {
            all.value = false;
          }
          type.value = true;
        });
      },
      child: Column(children: [
        Container(
          margin: EdgeInsets.all(8),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: blackBorder
                ? Border.all(color: Colors.black12)
                : Border.all(color: Colors.transparent),
            color: color,
          ),
        ),
        UIHelper.verticalSpaceSmall,
        Text(title),
        UIHelper.verticalSpaceSmall,
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
        setState(() {
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
        });
      },
      child: Column(children: [
        Container(
          margin: EdgeInsets.all(8),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
        UIHelper.verticalSpaceSmall,
        Text(title),
        UIHelper.verticalSpaceSmall,
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: Text(
          //     '색상',
          //     style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black26),
          //   ),
          // ),
          Wrap(
              children: List.generate(
                  keys.length,
                  (index) => values[index].value
                      ? selectedWidget(
                          keys[index], values[index], colors[index])
                      : unSelectedWidget(
                          keys[index], values[index], colors[index]))),
          // Row(
          //     children: List.generate(
          //         keys.sublist(3, 6).length,
          //         (index) => values[index + 3].value
          //             ? selectedWidget(keys[index + 3], values[index + 3])
          //             : unSelectedWidget(keys[index + 3], values[index + 3]))),
        ]);
  }
}
