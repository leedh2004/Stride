import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/models/user.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/card.dart';
import 'package:app/ui/widgets/swipe/input_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SwipeModel>(
        model: SwipeModel(
          Provider.of<DressRoomService>(context),
          Provider.of<SwipeService>(context),
        ),
        builder: (context, model, child) {
          if (model.trick) return FadeIn(delay: 1, child: (LoadingWidget()));
          if (Provider.of<SwipeService>(context).init == false) {
            model.initCards();
            if (Provider.of<DressRoomService>(context).init == false) {
              Provider.of<DressRoomService>(context).getDressRoom();
            }
            return LoadingWidget();
          }
          return FadeIn(
            delay: 0.3,
            child: Stack(children: [
              Align(
                alignment: Alignment.topCenter,
                child: clothTypeBar(model),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    verticalDirection: VerticalDirection.up,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      UIHelper.verticalSpaceSmall,
                      Transform.scale(
                        scale: 1.5,
                        child: Switch(
                          value: enabled,
                          onChanged: (value) async {
                            setState(() {
                              enabled = value;
                            });
                            if (enabled) {
                              Stride.analytics
                                  .logEvent(name: "SWIPE_SIZE_TOGGLE_ON");
                              await model.test();
                            } else {
                              Stride.analytics
                                  .logEvent(name: "SWIPE_SIZE_TOGGLE_OFF");
                            }
                          },
                          activeColor: backgroundColor,
                        ),
                      ),
                      buttonRow(model),
                      UIHelper.verticalSpaceSmall,
                      SwipeCardSection(context, model),
                    ]),
              ),
            ]),
          );
        });
  }

  Widget clothTypeBar(SwipeModel model) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(children: [
        Expanded(
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(TYPE.length, (index) {
                return InkWell(
                  onTap: () {
                    setState(() => model.changeType('${TYPE[index]}'));
                    Stride.analytics.logEvent(
                      name: 'SWIPE_CHANGE_MENU_${TYPE[index]}',
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      '${TYPE[index][0].toUpperCase() + TYPE[index].substring(1)}',
                      style: model.type == TYPE[index]
                          ? subHeaderMainColorStyle
                          : subHeaderStyle,
                    ),
                  ),
                );
              })),
        ),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '>',
              style: subHeaderStyle,
            ))
      ]),
    );
  }

  Widget buttonRow(SwipeModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: FaIcon(
              FontAwesomeIcons.times,
              size: 30.0,
              color: Color.fromRGBO(72, 116, 213, 1),
            ),
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              SwipeCard item = Provider.of<SwipeService>(context)
                  .items[model.type][model.index];
              Stride.analytics.logViewItem(
                  itemId: item.product_id.toString(),
                  itemName: item.product_name,
                  itemCategory: item.shop_name);
              model.purchaseItem(item.product_id);
              return ProductWebView(item.product_url, item.shop_name);
            }));
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: FaIcon(
            FontAwesomeIcons.gift,
            size: 30.0,
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
            FontAwesomeIcons.heart,
            size: 30.0,
            color: pinkColor,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ],
    );
  }
}
