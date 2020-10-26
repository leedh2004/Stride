import 'package:app/core/models/recentItem.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  List<RecentItem> items;
  RecentItemModel model;
  ItemRow(this.items, this.model);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 400,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(items.length,
              (index) => RecommendItemWidget(items[index], model)),
        ),
      ),
    ]);
  }
}

// const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
