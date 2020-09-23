import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class SizeFilter extends StatefulWidget {
  StrideUser user;
  SizeFilter(this.user);
  @override
  _SizeFilterState createState() => _SizeFilterState();
}

class _SizeFilterState extends State<SizeFilter> {
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
    showWidget = SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
            padding: EdgeInsets.all(20),
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
      ]),
    );
    return showWidget;
  }
}

class InputThirdPage extends StatefulWidget {
  var shoulderRange;
  var shoulderflag;
  var breastRange;
  var breastflag;
  var waistRange;
  var waistflag;
  var hipRange;
  var hipflag;
  var thighRange;
  var thighflag;
  InputThirdPage(
      {this.shoulderRange,
      this.shoulderflag,
      this.breastRange,
      this.breastflag,
      this.waistRange,
      this.waistflag,
      this.hipRange,
      this.hipflag,
      this.thighRange,
      this.thighflag});

  @override
  _InputThirdPageState createState() => _InputThirdPageState();
}

class _InputThirdPageState extends State<InputThirdPage> {
  Widget mySlider(String type, FlagWrapper flag, RangeWrapper rangeWrapper,
      double maxRange, double minRange) {
    String unit = 'cm';
    if (type == '허리(둘레)') {
      unit = '인치';
    }
    return Column(children: [
      Row(
        children: [
          Text(
            '$type',
            style: TextStyle(fontSize: 16),
          ),
          Checkbox(
            activeColor: Colors.black,
            checkColor: Colors.white,
            value: flag.value,
            onChanged: (bool value) {
              setState(() {
                flag.value = !flag.value;
              });
            },
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                TextSpan(
                    text: '${rangeWrapper.value.start.toInt()}',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: unit),
                TextSpan(text: ' ~ '),
                TextSpan(
                    text: '${rangeWrapper.value.end.toInt()}',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: unit),
              ]))
        ],
      ),
      RangeSlider(
          activeColor: Colors.black,
          inactiveColor: Colors.black26,
          max: maxRange,
          min: minRange,
          values: rangeWrapper.value,
          onChanged: flag.value
              ? (RangeValues range) {
                  setState(() => rangeWrapper.value = range);
                }
              : null),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mySlider('어깨(단면)', widget.shoulderflag, widget.shoulderRange, 50, 30),
      mySlider('가슴(둘레)', widget.breastflag, widget.breastRange, 110, 70),
      mySlider('허리(둘레)', widget.waistflag, widget.waistRange, 40, 20),
      mySlider('엉덩이(둘레)', widget.hipflag, widget.hipRange, 110, 80),
      mySlider('허벅지(단면)', widget.thighflag, widget.thighRange, 45, 18),
// 아께 30 ~ 50
      // 가슴 30 ~ 60
      // 허리 20 ~ 50
      // 엉덩이 30 ~ 60
      // 허벅지 20 ~ 40
    ]);
  }
}
