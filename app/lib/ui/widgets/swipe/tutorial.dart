import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget tutorialTextWidget(int tutorial_like) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                          padding: EdgeInsets.all(4),
                          child: FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: pinkColor,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(4),
                          child: FaIcon(FontAwesomeIcons.heart,
                              color: Colors.white30),
                        ))),
          Text(
            "가볍게 좌우로 스와이프 해보세요!",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "카드를 왼쪽으로 스와이프하면 '별로예요', 오른쪽으로 스와이프하면 '좋아요'",
            style: TextStyle(color: Colors.white, fontSize: 10),
          )
        ],
      ),
    ),
  );
}
