import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
import 'package:app/core/services/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/swipe/input_third.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeInputDialog extends StatefulWidget {
  StrideUser user;
  SizeInputDialog(this.user);
  @override
  _SizeInputDialogState createState() => _SizeInputDialogState();
}

class _SizeInputDialogState extends State<SizeInputDialog> {
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

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
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
              Provider.of<StrideUser>(context, listen: false).profile_flag =
                  true;
              Navigator.pop(context);
            }
          },
        ),
      )
    ]);
    return showWidget;
  }
}
