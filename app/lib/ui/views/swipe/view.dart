import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/loading.dart';
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
  //TabController tabController;
  bool enabled = true;
  String type = 'all';
  @override
  Widget build(BuildContext context) {
    int type = Provider.of<SwipeService>(context).type;
    return Consumer<List<List<SwipeCard>>>(
      builder: (context, items, child) {
        print("밑에게 바뀌면돼");
        print(type);
        if (items == null || items[type].length < 2) {
          return LoadingWidget();
        } else {
          return BaseWidget<SwipeModel>(
              model: SwipeModel(
                  Provider.of<Api>(context),
                  Provider.of<DressRoomService>(context),
                  Provider.of<SwipeService>(context),
                  items),
              builder: (context, model, child) {
                print("new build!");
                print(items[type][0].product_name);
                return Column(children: [
                  clothTypeBar(model),
                  SwipeCardSection(context, model),
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
                    ),
                  ),
                  buttonRow(),
                  UIHelper.verticalSpaceMedium
                ]);
              });
        }
      },
    );
  }

  Widget clothTypeBar(SwipeModel model) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 20),
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            onTap: () => {setState(() => model.changeType('all'))},
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'All',
                style:
                    model.type == 0 ? subHeaderMainColorStyle : subHeaderStyle,
              ),
            ),
          ),
          InkWell(
            onTap: () => {
              setState(() {
                model.changeType('top');
                type = '123';
              })
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Top',
                style:
                    model.type == 1 ? subHeaderMainColorStyle : subHeaderStyle,
              ),
            ),
          ),
          InkWell(
            onTap: () => {setState(() => model.changeType('skirt'))},
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Skirt',
                style:
                    model.type == 2 ? subHeaderMainColorStyle : subHeaderStyle,
              ),
            ),
          ),
          InkWell(
            onTap: () => {setState(() => model.changeType('pants'))},
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Pants',
                style:
                    model.type == 3 ? subHeaderMainColorStyle : subHeaderStyle,
              ),
            ),
          ),
          InkWell(
            onTap: () => {setState(() => model.changeType('dress'))},
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Dress',
                style:
                    model.type == 4 ? subHeaderMainColorStyle : subHeaderStyle,
              ),
            ),
          )
        ],
      ),
    );
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
}
