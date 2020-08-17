import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/swipe/input_first.dart';
import 'package:app/ui/widgets/swipe/input_second.dart';
import 'package:app/ui/widgets/swipe/input_third.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class InputInfoDialog extends StatefulWidget {
  @override
  _InputInfoDialogState createState() => _InputInfoDialogState();
}

class _InputInfoDialogState extends State<InputInfoDialog> {
  int page = 1;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    if (page == 1) {
      showWidget = FadeIn(
        delay: 1,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(padding: EdgeInsets.all(40), child: InputFirstPage()),
          Material(
            color: backgroundColor,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text('다음', style: TextStyle(color: Colors.white)),
              ),
              onTap: () {
                setState(() => page++);
              },
            ),
          )
        ]),
      );
    } else if (page == 2) {
      showWidget = Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.all(40), child: InputSecondPage()),
        Material(
          color: backgroundColor,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('다음', style: TextStyle(color: Colors.white)),
            ),
            onTap: () {
              setState(() {
                page++;
              });
            },
          ),
        )
      ]);
    } else {
      showWidget = Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.all(40), child: InputThirdPage()),
        Material(
          color: backgroundColor,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('완료', style: TextStyle(color: Colors.white)),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        )
      ]);
    }
    return showWidget;
  }
}
