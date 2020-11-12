import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/widgets/mypage/input_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

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
                // Text(
                //   '사이즈는 마이페이지에서 변경 가능합니다.',
                //   style: TextStyle(color: Colors.black45, fontSize: 12),
                // )
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
        InkWell(
          onTap: () {
            Stride.logEvent(name: 'FILTER_GO_TO_SIZE_CHANGE_BUTTON_CLICKED');
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SizeInputDialog(
                  Provider.of<AuthenticationService>(context, listen: false)
                      .userController
                      .value);
            }));
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Text(
              '사이즈 변경하러 가기 >',
              style: TextStyle(color: Color(0xFF5125BA), fontSize: 12),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF4F4FC)),
          ),
        )
      ],
    );
  }
}
