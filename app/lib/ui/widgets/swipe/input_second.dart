import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/circle.dart';
import 'package:app/ui/widgets/swipe/purple_circle.dart';
import 'package:flutter/material.dart';

class InputSecondPage extends StatefulWidget {
  @override
  _InputSecondPageState createState() => _InputSecondPageState();
}

class _InputSecondPageState extends State<InputSecondPage> {
  var xs = false;
  var s = true;
  var m = true;
  var l = false;
  var xl = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Circle(),
            UIHelper.horizontalSpaceSmall,
            PurpleCircle(),
            UIHelper.horizontalSpaceSmall,
            Circle()
          ],
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
              TextSpan(text: '관심있는 '),
              TextSpan(text: '사이즈', style: inputPurpleStyle),
              TextSpan(text: ' 를 알려주세요'),
            ])),
        UIHelper.verticalSpaceSmall,
        Text(
          '나에게 맞는 옷을 추천해드려요',
          style: TextStyle(fontSize: 12.0),
        ),
        UIHelper.verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              color: xs ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  xs = !xs;
                });
              },
              child:
                  Text('XS', style: xs ? TextStyle(color: Colors.white) : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: s ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  s = !s;
                });
              },
              child:
                  Text('S', style: s ? TextStyle(color: Colors.white) : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: m ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  m = !m;
                });
              },
              child:
                  Text('M', style: m ? TextStyle(color: Colors.white) : null),
            ),
          ],
        ),
        UIHelper.verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              color: l ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  l = !l;
                });
              },
              child:
                  Text('L', style: l ? TextStyle(color: Colors.white) : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: xl ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  xl = !xl;
                });
              },
              child:
                  Text('XL', style: xl ? TextStyle(color: Colors.white) : null),
            ),
          ],
        )
      ],
    );
  }
}
