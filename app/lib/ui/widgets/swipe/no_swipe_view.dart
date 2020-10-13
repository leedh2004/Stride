import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class NoSwipeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: backgroundColor,
      child: Align(
        alignment: Alignment.center + Alignment(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/search.png',
              width: 100,
              height: 100,
            ),
            Text("상품목록이 없어요", style: headerStyle),
            UIHelper.verticalSpaceSmall,
            Text("필터 조건을 조금 더 완화해 주세요", style: dressRoomsubHeaderStyle),
          ],
        ),
      ),
    );
  }
}
