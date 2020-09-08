import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/config.dart';
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';
import '../service_view.dart';

class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  //TabController tabController;

  bool enabled = true;
  String type = 'all';
  double like_opacity = 0;
  double dislike_opacity = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Provider.of<ConfigService>(context, listen: false).currentVersion !=
              Provider.of<ConfigService>(context, listen: false)
                  .updateVersion &&
          !Provider.of<ConfigService>(context, listen: false).alreadyShow) {
        print(
            Provider.of<ConfigService>(context, listen: false).currentVersion);
        print(Provider.of<ConfigService>(context, listen: false).updateVersion);
        ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text('Stride앱의 최신 버전이 나왔습니다!'),
        ));
        Provider.of<ConfigService>(context, listen: false).alreadyShow = true;
      }
    });

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
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  buttonRow(model),
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
                  UIHelper.verticalSpaceSmall,
                ]),
              ),
              SwipeCardSection(context, model),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: dislike_opacity,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.all(3),
                      child: FaIcon(
                        FontAwesomeIcons.times,
                        size: 100,
                        color: blueColor,
                      )),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: like_opacity,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.all(3),
                      child: FaIcon(
                        FontAwesomeIcons.solidHeart,
                        size: 100,
                        color: pinkColor,
                      )),
                ),
              ),
            ]),
          );
        });
  }

  Widget clothTypeBar(SwipeModel model) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
          onPressed: () async {
            model.dislikeRequest();
            setState(() {
              dislike_opacity = 1;
            });
            await Future.delayed(Duration(milliseconds: 300));
            setState(() {
              dislike_opacity = 0;
            });
            model.nextItem();
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: SvgPicture.asset(
              'images/times.svg',
              width: 25.0,
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
          child: SvgPicture.asset(
            'images/buy.svg',
            width: 25.0,
            color: backgroundColor,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: () async {
            model.likeRequest();
            setState(() {
              like_opacity = 1;
            });
            await Future.delayed(Duration(milliseconds: 300));
            setState(() {
              like_opacity = 0;
            });
            model.nextItem();
          },
          elevation: 2.0,
          fillColor: Colors.white,
          child: SvgPicture.asset(
            'images/like.svg',
            width: 30.0,
            color: pinkColor,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        ),
      ],
    );
  }
}
