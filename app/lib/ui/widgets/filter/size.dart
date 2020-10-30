import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeFilter extends StatefulWidget {
  SwipeModel model;
  // StrideUser user;
  SizeFilter(this.model);
  @override
  _SizeFilterState createState() => _SizeFilterState();
}

class _SizeFilterState extends State<SizeFilter> {
  bool flag;
  @override
  Widget build(BuildContext context) {
    flag = widget.model.filter.size_toggle;
    // print(widget.user.shoulder[0]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '사이즈에 맞는 옷만 보기',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '사이즈는 마이페이지에서 변경 가능합니다.',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                )
              ],
            ),
            CupertinoSwitch(
                // activeTrackColor: Colors.lightGreenAccent,
                activeColor: Color(0xFF8569EF),
                value: flag,
                onChanged: (value) {
                  widget.model.setSize(value);
                  setState(() {});
                }),
          ],
        ),
      ],
    );
  }
}
