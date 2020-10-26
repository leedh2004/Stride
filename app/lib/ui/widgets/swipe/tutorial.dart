import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget tutorialTextWidget(int tutorial_like) {
  return Container(
    margin: EdgeInsets.fromLTRB(16, 50, 16, 0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(63, 70, 82, 0.8)),
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (index) => tutorial_like > index
                    ? Padding(
                        padding: EdgeInsets.all(8),
                        child: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: pinkColor,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: FaIcon(FontAwesomeIcons.heart,
                            color: Colors.white30),
                      ))),
        Text(
          '카드를 좌/우로 스와이프해 아이템을 평가해보세요!',
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}
