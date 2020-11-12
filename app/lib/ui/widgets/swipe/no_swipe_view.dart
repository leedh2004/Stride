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
              'assets/error_search.png',
              width: 150,
            ),
            SizedBox(
              height: 13,
            ),
            Text("상품목록이 없어요",
                style: TextStyle(
                  color: Color(0xFF616576),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                )),
            SizedBox(
              height: 15,
            ), // UIHelper.verticalSpaceSmall,
            Text("필터 조건을 조금 더 완화해 주세요",
                style: TextStyle(color: Color(0xFF888C93), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
