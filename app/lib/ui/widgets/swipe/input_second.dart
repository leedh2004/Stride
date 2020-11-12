import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/circle.dart';
import 'package:app/ui/widgets/swipe/purple_circle.dart';
import 'package:flutter/material.dart';

class InputSecondPage extends StatefulWidget {
  Map<String, bool> size;
  InputSecondPage(this.size);
  @override
  _InputSecondPageState createState() => _InputSecondPageState();
}

class _InputSecondPageState extends State<InputSecondPage> {
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
              color: widget.size['xs'] ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  widget.size['xs'] = !widget.size['xs'];
                });
              },
              child: Text('XS',
                  style: widget.size['xs']
                      ? TextStyle(color: Colors.white)
                      : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: widget.size['s'] ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  widget.size['s'] = !widget.size['s'];
                });
              },
              child: Text('S',
                  style:
                      widget.size['s'] ? TextStyle(color: Colors.white) : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: widget.size['m'] ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  widget.size['m'] = !widget.size['m'];
                });
              },
              child: Text('M',
                  style:
                      widget.size['m'] ? TextStyle(color: Colors.white) : null),
            ),
          ],
        ),
        UIHelper.verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              color: widget.size['l'] ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  widget.size['l'] = !widget.size['l'];
                });
              },
              child: Text('L',
                  style:
                      widget.size['l'] ? TextStyle(color: Colors.white) : null),
            ),
            UIHelper.horizontalSpaceSmall,
            RaisedButton(
              color: widget.size['xl'] ? backgroundColor : null,
              onPressed: () {
                setState(() {
                  widget.size['xl'] = !widget.size['xl'];
                });
              },
              child: Text('XL',
                  style: widget.size['xl']
                      ? TextStyle(color: Colors.white)
                      : null),
            ),
          ],
        )
      ],
    );
  }
}
