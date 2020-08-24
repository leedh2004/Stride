import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/circle.dart';
import 'package:app/ui/widgets/swipe/purple_circle.dart';
import 'package:flutter/material.dart';

class InputFirstPage extends StatefulWidget {
  @override
  _InputFirstPageState createState() => _InputFirstPageState();
}

class _InputFirstPageState extends State<InputFirstPage> {
  double _age = 20;
  double _height = 160;
  double _weight = 55;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PurpleCircle(),
            UIHelper.horizontalSpaceSmall,
            Circle(),
            UIHelper.horizontalSpaceSmall,
            Circle()
          ],
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
              TextSpan(text: '나이, 키, 몸무게', style: inputPurpleStyle),
              TextSpan(text: ' 를 알려주세요'),
            ])),
        UIHelper.verticalSpaceSmall,
        Text(
          '나에게 맞는 상품들을 추천해드려요',
          style: TextStyle(fontSize: 12.0),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black12,
              inactiveTrackColor: Colors.black12,
              trackHeight: 3.0,
              thumbColor: backgroundColor,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0),
              overlayColor: Colors.purple.withAlpha(40),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              onChanged: (value) => setState(() {
                _age = value;
              }),
              value: _age,
              max: 40,
              min: 13,
            ),
          ),
        ),
        _age.toInt() == 13
            ? RichText(
                text: TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                    TextSpan(text: '13', style: inputPurpleStyle),
                    TextSpan(text: ' 세 이하')
                  ]))
            : _age.toInt() == 40
                ? RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(text: '40', style: inputPurpleStyle),
                        TextSpan(text: ' 세 이상')
                      ]))
                : RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(
                            text: '${_age.toInt()}', style: inputPurpleStyle),
                        TextSpan(text: ' 세')
                      ])),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black12,
              inactiveTrackColor: Colors.black12,
              trackHeight: 3.0,
              thumbColor: backgroundColor,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0),
              overlayColor: Colors.purple.withAlpha(40),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              onChanged: (value) => setState(() {
                _height = value;
              }),
              value: _height,
              max: 175,
              min: 145,
            ),
          ),
        ),
        _height.toInt() == 145
            ? RichText(
                text: TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                    TextSpan(text: '145', style: inputPurpleStyle),
                    TextSpan(text: ' cm 이하')
                  ]))
            : _height.toInt() == 175
                ? RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(text: '175', style: inputPurpleStyle),
                        TextSpan(text: ' cm 이상')
                      ]))
                : RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(
                            text: '${_height.toInt()}',
                            style: inputPurpleStyle),
                        TextSpan(text: ' cm')
                      ])),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black12,
              inactiveTrackColor: Colors.black12,
              trackHeight: 3.0,
              thumbColor: backgroundColor,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18.0),
              overlayColor: Colors.purple.withAlpha(40),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              onChanged: (value) => setState(() {
                _weight = value;
              }),
              value: _weight,
              max: 70,
              min: 40,
            ),
          ),
        ),
        _weight.toInt() == 40
            ? RichText(
                text: TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                    TextSpan(text: '40', style: inputPurpleStyle),
                    TextSpan(text: ' kg 이하')
                  ]))
            : _weight.toInt() == 70
                ? RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(text: '70', style: inputPurpleStyle),
                        TextSpan(text: ' kg 이상')
                      ]))
                : RichText(
                    text: TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: [
                        TextSpan(
                            text: '${_weight.toInt()}',
                            style: inputPurpleStyle),
                        TextSpan(text: ' kg')
                      ])),
      ],
    );
  }
}
