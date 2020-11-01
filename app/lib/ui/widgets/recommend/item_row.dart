import 'package:app/core/models/recentItem.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/recommend/item.dart';
import 'package:flutter/material.dart';

class ItemRow extends StatefulWidget {
  List<RecentItem> items;
  RecentItemModel model;
  ScrollController _controller;
  ItemRow(this.items, this.model, this._controller);
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  @override
  Widget build(BuildContext context) {
    // _controller.animateTo(0, duration: Duration(seconds: 1));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 400,
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: widget._controller,
          children: List.generate(
              widget.items.length,
              (index) =>
                  RecommendItemWidget(widget.items[index], widget.model)),
        ),
      ),
    ]);
  }
}

// const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
