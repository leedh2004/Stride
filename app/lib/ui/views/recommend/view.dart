import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:app/ui/widgets/recommend/item_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> items =
        Provider.of<DressRoomService>(context).items[0].sublist(0, 20);
    print(items);

    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이도현님이 평가한 아이템'),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [Text('좋아요'), Text('252')],
                      ),
                    ),
                    UIHelper.horizontalSpaceMedium,
                    VerticalDivider(
                      color: Colors.black,
                      width: 1,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Container(
                      child: Column(
                        children: [Text('콜렉션'), Text('88')],
                      ),
                    ),
                    UIHelper.horizontalSpaceMedium,
                    VerticalDivider(
                      color: Colors.black,
                      width: 1,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Container(
                      child: Column(
                        children: [Text('싫어요'), Text('1234')],
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
              ItemRow('최근에 평가한 아이템', items),
              ItemRow('스트릿 컨셉의 아이템', items),
              ItemRow('금주의 신상', items),
            ],
          )
        ],
      ),
    );
  }
}
