import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> items =
        Provider.of<DressRoomService>(context).items[0].sublist(0, 20);
    print(items);

    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Text('오늘의 신상'),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(items.length,
                      (index) => RecommendItemWidget(items[index])),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
