import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/swipe/card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  TabController tabController;
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      BaseWidget<SwipeModel>(
          model: SwipeModel(api: Provider.of(context)),
          onModelReady: (model) {
            model.fetchItems();
          },
          builder: (context, model, child) {
            return SwipeCardSection(context);
          }),
      Transform.scale(
        scale: 1.5,
        child: Switch(
          value: enabled,
          onChanged: (value) {
            setState(() {
              enabled = value;
            });
          },
          activeColor: backgroundColor,
          //activeThumbImage: AssetImage('images/logo.png')
        ),
      ),
      buttonRow(),
      UIHelper.verticalSpaceMedium
    ]);
  }
}

Widget buttonRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.times,
          size: 25.0,
          color: Colors.red,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.gift,
          size: 25.0,
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: FaIcon(
          FontAwesomeIcons.circle,
          size: 25.0,
          color: Color.fromRGBO(90, 193, 142, 1),
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
    ],
  );
}
