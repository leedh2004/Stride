import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/mypage/input_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeInputDialog extends StatefulWidget {
  StrideUser user;
  SizeInputDialog(this.user);
  @override
  _SizeInputDialogState createState() => _SizeInputDialogState();
}

class _SizeInputDialogState extends State<SizeInputDialog> {
  var _shoulderflag = FlagWrapper(false);
  var _breastflag = FlagWrapper(false);
  var _waistflag = FlagWrapper(false);
  var _hipflag = FlagWrapper(false);
  var _thighflag = FlagWrapper(false);
  var _shoulderRange = RangeWrapper(RangeValues(38, 42));
  var _breastRange = RangeWrapper(RangeValues(83, 93));
  var _waistRange = RangeWrapper(RangeValues(25, 29));
  var _hipRange = RangeWrapper(RangeValues(88, 96));
  var _thighRange = RangeWrapper(RangeValues(24, 32));

  @override
  Widget build(BuildContext context) {
    // print(widget.user.shoulder[0]);
    if (widget.user.shoulder != null) {
      _shoulderRange = RangeWrapper(
          RangeValues(widget.user.shoulder[0], widget.user.shoulder[1]));
      _shoulderflag = FlagWrapper(true);
    }
    if (widget.user.bust != null) {
      _breastRange =
          RangeWrapper(RangeValues(widget.user.bust[0], widget.user.bust[1]));
      _breastflag = FlagWrapper(true);
    }
    if (widget.user.hip != null) {
      _hipRange =
          RangeWrapper(RangeValues(widget.user.hip[0], widget.user.hip[1]));
      _hipflag = FlagWrapper(true);
    }
    if (widget.user.thigh != null) {
      _thighRange =
          RangeWrapper(RangeValues(widget.user.thigh[0], widget.user.thigh[1]));
      _thighflag = FlagWrapper(true);
    }
    if (widget.user.waist != null) {
      _waistRange =
          RangeWrapper(RangeValues(widget.user.waist[0], widget.user.waist[1]));
      _waistflag = FlagWrapper(true);
    }

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
    return showWidget;
  }
}
