import 'package:app/core/models/recentItem.dart';
import 'package:flutter/material.dart';

class DressRoomItemView extends StatefulWidget {
  final List<RecentItem> items;
  DressRoomItemView(this.items);
  @override
  _DressRoomItemViewState createState() => _DressRoomItemViewState();
}

class _DressRoomItemViewState extends State<DressRoomItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('!!'),
      ),
    );
  }
}
