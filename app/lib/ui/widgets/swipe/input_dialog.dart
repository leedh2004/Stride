import 'dart:math';

import 'package:app/core/models/tutorial.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/swipe/input_first.dart';
import 'package:app/ui/widgets/swipe/input_second.dart';
import 'package:app/ui/widgets/swipe/input_third.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputInfoDialog extends StatefulWidget {
  @override
  _InputInfoDialogState createState() => _InputInfoDialogState();
}

class _InputInfoDialogState extends State<InputInfoDialog> {
  int page = 1;
  bool _visible = false;
  double age = 20;
  var _shoulderRange = RangeWrapper(RangeValues(38, 44));
  var _shoulderflag = FlagWrapper(true);
  var _breastRange = RangeWrapper(RangeValues(83, 98));
  var _breastflag = FlagWrapper(true);
  var _waistRange = RangeWrapper(RangeValues(25, 31));
  var _waistflag = FlagWrapper(true);
  var _hipRange = RangeWrapper(RangeValues(88, 100));
  var _hipflag = FlagWrapper(true);
  var _thighRange = RangeWrapper(RangeValues(24, 36));
  var _thighflag = FlagWrapper(true);

  Map<String, bool> size = {
    'xs': false,
    's': true,
    'm': true,
    'l': false,
    'xl': false
  };

  callbackAge(newAge) {
    setState(() {
      age = newAge;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    // if (page == 1) {
    showWidget = FadeIn(
      delay: 1,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: EdgeInsets.all(40),
            child: InputFirstPage(age, callbackAge)),
        Material(
          color: backgroundColor,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('다음', style: TextStyle(color: Colors.white)),
            ),
            onTap: () async {
              int _age = age.toInt();
              var now = DateTime.now();
              int birth = now.year - _age + 1;
              if (await Provider.of<TutorialService>(context, listen: false)
                  .sendBirth(birth)) {
                setState(() => page++);
              }
              Navigator.maybePop(context);
            },
          ),
        )
      ]),
    );
    return showWidget;
  }
}
