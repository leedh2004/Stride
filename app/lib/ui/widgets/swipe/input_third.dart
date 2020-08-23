import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/circle.dart';
import 'package:app/ui/widgets/swipe/purple_circle.dart';
import 'package:app/ui/widgets/swipe/sliderTheme.dart';
import 'package:flutter/material.dart';

class InputThirdPage extends StatefulWidget {
  @override
  _InputThirdPageState createState() => _InputThirdPageState();
}

class RangeWrapper {
  RangeValues value;
  RangeWrapper(this.value);
}

class FlagWrapper {
  bool value;
  FlagWrapper(this.value);
}

class _InputThirdPageState extends State<InputThirdPage> {
  var _shoulderRange = RangeWrapper(RangeValues(35, 45));
  var _shoulderflag = FlagWrapper(true);
  var _breastRange = RangeWrapper(RangeValues(40, 50));
  var _breastflag = FlagWrapper(true);
  var _waistRange = RangeWrapper(RangeValues(30, 40));
  var _waistflag = FlagWrapper(true);
  var _hipRange = RangeWrapper(RangeValues(40, 50));
  var _hipflag = FlagWrapper(true);
  var _thighRange = RangeWrapper(RangeValues(30, 35));
  var _thighflag = FlagWrapper(true);
  // 아께 30 ~ 50
  // 가슴 30 ~ 60
  // 허리 20 ~ 50
  // 엉덩이 30 ~ 60
  // 허벅지 20 ~ 40
  // double _lowerValueFormatter = 20.0;
  // double _upperValueFormatter = 20.0;
  //어깨, 가슴, 허리, 힙, 밑단, 암홀, 소매길이,
  Widget mySlider(String type, FlagWrapper flag, RangeWrapper rangeWrapper,
      double maxRange, double minRange) {
    return Column(children: [
      Row(
        children: [
          Text(
            '$type',
            style: TextStyle(fontSize: 16),
          ),
          Checkbox(
            activeColor: backgroundColor,
            checkColor: Colors.white,
            value: flag.value,
            onChanged: (bool value) {
              setState(() {
                flag.value = !flag.value;
              });
            },
          ),
          Expanded(
            child: PurpleSliderTheme(
                context,
                RangeSlider(
                    max: maxRange,
                    min: minRange,
                    values: rangeWrapper.value,
                    onChanged: flag.value
                        ? (RangeValues range) {
                            setState(() => rangeWrapper.value = range);
                          }
                        : null)),
          ),
        ],
      ),
      RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              children: [
            TextSpan(
                text: '${rangeWrapper.value.start.toInt()}',
                style: TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: 'cm '),
            TextSpan(text: '~'),
            TextSpan(
                text: '${rangeWrapper.value.end.toInt()}',
                style: TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: 'cm '),
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Circle(),
          UIHelper.horizontalSpaceSmall,
          Circle(),
          UIHelper.horizontalSpaceSmall,
          PurpleCircle(),
        ],
      ),
      RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              children: [
            TextSpan(text: '이 정도 '),
            TextSpan(text: '사이즈', style: inputPurpleStyle),
            TextSpan(text: '가 적당하신가요?'),
          ])),
      UIHelper.verticalSpaceSmall,
      Text(
        '잘 모르시는 부분은 체크박스를 해제 해주세요!',
        style: TextStyle(fontSize: 12.0),
      ),
      Text(
        '마이페이지에서 변경 가능합니다',
        style: TextStyle(fontSize: 12.0),
      ),
      UIHelper.verticalSpaceSmall,
      mySlider('어깨', _shoulderflag, _shoulderRange, 50, 30),
      mySlider('가슴', _breastflag, _breastRange, 60, 30),
      mySlider('허리', _waistflag, _waistRange, 50, 20),
      mySlider('엉덩이', _hipflag, _hipRange, 60, 30),
      mySlider('허벅지', _thighflag, _thighRange, 40, 20),
// 아께 30 ~ 50
      // 가슴 30 ~ 60
      // 허리 20 ~ 50
      // 엉덩이 30 ~ 60
      // 허벅지 20 ~ 40
    ]);
  }
}
