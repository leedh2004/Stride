import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/widgets/dress_room.dart';

class DressRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: DressRoom()),
      Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
              color: backgroundColor,
              onPressed: () {},
              child: Text('Make', style: whiteStyle),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              color: Colors.black45,
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: FaIcon(FontAwesomeIcons.trash),
              onPressed: () {},
            ),
          ),
        ],
      )
    ]);
  }
}
