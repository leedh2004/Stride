import 'package:app/core/models/product.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  List<Product> items;
  String title;
  ItemRow(this.title, this.items);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title),
      SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
              items.length, (index) => RecommendItemWidget(items[index])),
        ),
      ),
      UIHelper.verticalSpaceMedium,
    ]);
  }
}
