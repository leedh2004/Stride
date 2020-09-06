import 'dart:math';

import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
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
  var _shoulderRange;
  var _shoulderflag = FlagWrapper(true);
  var _breastRange;
  var _breastflag = FlagWrapper(true);
  var _waistRange;
  var _waistflag = FlagWrapper(true);
  var _hipRange;
  var _hipflag = FlagWrapper(true);
  var _thighRange;
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
    if (page == 1) {
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
              },
            ),
          )
        ]),
      );
    } else if (page == 2) {
      showWidget = Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: EdgeInsets.all(40), child: InputSecondPage(size)),
        Material(
          color: backgroundColor,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('다음', style: TextStyle(color: Colors.white)),
            ),
            onTap: () {
              double shoulderStart = 100;
              double shoulderEnd = 0;
              double bustStart = 100;
              double bustEnd = 0;
              double waistStart = 100;
              double waistEnd = 0;
              double hipStart = 100;
              double hipEnd = 0;
              double thighStart = 100;
              double thighEnd = 0;
              List<String> keys = size.keys.toList();
              for (String key in keys) {
                print(key);
                if (size[key]) {
                  print("ON");
                  print(sizeRange[key]['shoulder'][0]);
                  shoulderStart =
                      min(shoulderStart, sizeRange[key]['shoulder'][0]);
                  shoulderEnd = max(shoulderEnd, sizeRange[key]['shoulder'][1]);
                  bustStart = min(bustStart, sizeRange[key]['bust'][0]);
                  bustEnd = max(bustEnd, sizeRange[key]['bust'][1]);
                  waistStart = min(waistStart, sizeRange[key]['waist'][0]);
                  waistEnd = max(waistEnd, sizeRange[key]['waist'][1]);
                  hipStart = min(hipStart, sizeRange[key]['hip'][0]);
                  hipEnd = max(hipEnd, sizeRange[key]['hip'][1]);
                  thighStart = min(thighStart, sizeRange[key]['thigh'][0]);
                  thighEnd = max(thighEnd, sizeRange[key]['thigh'][1]);
                }
              }
              if (keys.length > 0) {
                setState(() {
                  _shoulderRange =
                      RangeWrapper(RangeValues(shoulderStart, shoulderEnd));
                  _breastRange = RangeWrapper(RangeValues(bustStart, bustEnd));
                  _waistRange = RangeWrapper(RangeValues(waistStart, waistEnd));
                  _hipRange = RangeWrapper(RangeValues(hipStart, hipEnd));
                  _thighRange = RangeWrapper(RangeValues(thighStart, thighEnd));
                  page++;
                });
              }
            },
          ),
        )
      ]);
    } else {
      showWidget = Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: EdgeInsets.all(40),
            child: InputThirdPage(
              shoulderRange: _shoulderRange,
              shoulderflag: _shoulderflag,
              breastRange: _breastRange,
              breastflag: _breastflag,
              waistRange: _waistRange,
              waistflag: _waistflag,
              hipRange: _hipRange,
              hipflag: _hipflag,
              thighRange: _thighRange,
              thighflag: _thighflag,
            )),
        Material(
          color: backgroundColor,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('완료', style: TextStyle(color: Colors.white)),
            ),
            onTap: () async {
              print(_shoulderRange.value);
              if (await Provider.of<TutorialService>(context, listen: false)
                  .sendSize([
                _waistRange,
                _hipRange,
                _thighRange,
                _shoulderRange,
                _breastRange
              ], [
                _waistflag,
                _hipflag,
                _thighflag,
                _shoulderflag,
                _breastflag
              ])) {
                Provider.of<AuthenticationService>(context, listen: false)
                    .changeUserSize([
                  _waistRange,
                  _hipRange,
                  _thighRange,
                  _shoulderRange,
                  _breastRange
                ], [
                  _waistflag,
                  _hipflag,
                  _thighflag,
                  _shoulderflag,
                  _breastflag
                ]);
                // Provider.of<StrideUser>(context, listen: false).profile_flag =
                //     true;
                Navigator.pop(context);
              }
            },
          ),
        )
      ]);
    }
    return showWidget;
  }
}
