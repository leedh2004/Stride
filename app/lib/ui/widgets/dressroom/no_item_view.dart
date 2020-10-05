import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class NoItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // color: backgroundColor,
        child: Align(
          alignment: Alignment.center + Alignment(0, -0.25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/love.png',
                width: 100,
                height: 100,
              ),
              Text("좋아하는 상품이 없어요", style: headerStyle),
              UIHelper.verticalSpaceSmall,
              Text("예쁜 아이템을 오른쪽으로 스와이프해서", style: dressRoomsubHeaderStyle),
              Text("나만의 드레스룸을 꾸며 보아요", style: dressRoomsubHeaderStyle),
            ],
          ),
        ),
      ),
    );
  }
}
