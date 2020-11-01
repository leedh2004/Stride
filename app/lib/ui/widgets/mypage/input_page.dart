import 'package:app/core/models/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/sliderTheme.dart';
import 'package:flutter/material.dart';

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
      SizedBox(
        height: 35,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          flag.value
              ? InkWell(
                  onTap: () {
                    setState(() {
                      flag.value = !flag.value;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFF8569EF)),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      flag.value = !flag.value;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFF3F4F8)),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
          SizedBox(
            width: 8,
          ),
          Text(
            '$type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          Spacer(),
          RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
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
      SizedBox(
        height: 21,
      ),
      PurpleSliderTheme(
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
      SizedBox(
        height: 21,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mySlider('어깨(단면)', widget.shoulderflag, widget.shoulderRange, 50, 30),
      Divider(),
      mySlider('가슴(둘레)', widget.breastflag, widget.breastRange, 110, 70),
      Divider(),

      mySlider('허리(둘레)', widget.waistflag, widget.waistRange, 40, 20),
      Divider(),

      mySlider('엉덩이(둘레)', widget.hipflag, widget.hipRange, 110, 80),
      Divider(),

      mySlider('허벅지(단면)', widget.thighflag, widget.thighRange, 45, 18),
// 아께 30 ~ 50
      // 가슴 30 ~ 60
      // 허리 20 ~ 50
      // 엉덩이 30 ~ 60
      // 허벅지 20 ~ 40
    ]);
  }
}
