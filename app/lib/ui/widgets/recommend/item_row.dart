import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  List<RecentItem> items;
  String title;
  RecentItemModel model;
  ItemRow(this.title, this.items, this.model);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: headerStyle,
      ),
      SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(items.length,
              (index) => RecommendItemWidget(items[index], model)),
        ),
      ),
      UIHelper.verticalSpaceMedium,
    ]);
  }
}

const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
