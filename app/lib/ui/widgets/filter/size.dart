import 'package:app/core/viewmodels/views/swipe.dart';
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
                activeColor: Colors.black,
                value: flag,
                onChanged: (value) {
                  widget.model.setSize(value);
                  setState(() {});
                }),
            Text(
              '사이즈에 맞는 옷만 보기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ],
        ),
        Text(
          '사이즈는 마이페이지에서 변경 가능합니다.',
          style: TextStyle(color: Colors.black45),
        )
      ],
    );
  }
}
