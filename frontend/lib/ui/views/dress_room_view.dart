import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/widgets/dress_room.dart';

class DressRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: DressRoom()),
      Container(
        color: backgroundColor,
        child: ButtonBar(
          children: <Widget>[Text('HI')],
        ),
      )
    ]);
  }
}
