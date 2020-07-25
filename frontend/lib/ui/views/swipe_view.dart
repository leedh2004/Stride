import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';
import 'package:frontend/ui/widgets/swipe_card.dart';

class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  TabController tabController;
  bool enabled = true;
  List<String> images = [
    "http://www.66girls.co.kr/web/product/big/202007/5a9e8bccd96339abf87e10692af292aa.jpg",
    "http://feelings.co.kr/web/product/big/20200522/e84c076c4409de9bc2a320d244e4642a.gif",
    "http://noncode.co.kr/web/product/medium/202007/ffae56a5932a52840d2a8de984be9e5b.jpg",
    "http://www.66girls.co.kr/web/product/big/201910/3091a301c1bcb448b04f8ab76761865c.jpg",
    "http://noncode.co.kr/web/product/medium/20200504/5692ff4070f3a2cc6f5b9c32d80a3365.jpg",
    "http://dailyjou.com/web/product/big/20200316/8624363fcc3489ca00a93c54d341f900.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SwipeCardSection(context),
      Transform.scale(
        scale: 1.5,
        child: Switch(
          value: enabled,
          onChanged: (value) {
            setState(() {
              enabled = value;
            });
          },
          activeColor: backgroundColor,
          //activeThumbImage: AssetImage('images/logo.png')
        ),
      ),
      buttonRow(),
      UIHelper.verticalSpaceMedium
    ]);
  }
}

Widget buttonRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.times,
          size: 25.0,
          color: Colors.red,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.gift,
          size: 25.0,
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.circle,
          size: 25.0,
          color: Color.fromRGBO(90, 193, 142, 1),
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
    ],
  );
}
