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
              Text("콜렉션에 상품이 없어요", style: headerStyle),
              UIHelper.verticalSpaceSmall,
              Text("마음에 드는 아이템을 저장해서", style: dressRoomsubHeaderStyle),
              Text("나만의 콜렉션룸을 꾸며 보아요", style: dressRoomsubHeaderStyle),
            ],
          ),
        ),
      ),
    );
  }
}
