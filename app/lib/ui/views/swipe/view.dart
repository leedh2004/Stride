import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/button_row.dart';
import 'package:app/ui/widgets/swipe/card.dart';
import 'package:app/ui/widgets/swipe/cloth_type_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../base_widget.dart';
import '../product_web_view.dart';
import '../service_view.dart';

class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  //TabController tabController;
  bool size_flag = false;
  String type = 'all';
  double like_opacity = 0, dislike_opacity = 0;
  bool onflag = false;
  GlobalKey buyButton = GlobalKey(),
      sizeToggle = GlobalKey(),
      rulerButton = GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  @override
  void initState() {
    initTargets();
    super.initState();
  }

  onTapDislikeButton(SwipeModel model) async {
    if (onflag) return false;
    onflag = true;
    Stride.analytics.logEvent(name: 'SWIPE_HATE_BUTTON_CLICKED');
    model.dislikeRequest();
    setState(() {
      dislike_opacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      dislike_opacity = 0;
    });
    model.nextItem();
    onflag = false;
  }

  onTapPurchaseButton(SwipeModel model) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      SwipeCard item =
          Provider.of<SwipeService>(context).items[model.type][model.index];
      Stride.analytics
          .logEvent(name: 'SWIPE_PURCHASE_BUTTON_CLICKED', parameters: {
        'itemId': item.product_id.toString(),
        'itemName': item.product_name,
        'itemCategory': item.shop_name
      });

      model.purchaseItem(item.product_id);
      return ProductWebView(item.product_url, item.shop_name);
    }));
  }

  onTapLikeButton(SwipeModel model) async {
    if (onflag) return false;
    Stride.analytics.logEvent(name: 'SWIPE_LIKE_BUTTON_CLICKED');
    onflag = true;
    model.likeRequest();
    setState(() {
      like_opacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      like_opacity = 0;
    });
    model.nextItem();
    onflag = false;
  }

  onTapSizeButton(SwipeModel model, value) async {
    setState(() {
      size_flag = value;
    });
    if (size_flag) {
      ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Row(children: [
            Icon(
              Icons.check,
              color: backgroundColor,
            ),
            UIHelper.horizontalSpaceMedium,
            Text('자신의 사이즈에 맞는 옷만 봅니다'),
          ])));
    }
    model.flagChange();
    if (size_flag) {
      Stride.analytics.logEvent(name: "SWIPE_SIZE_TOGGLE_ON");
      model.test();
    } else {
      Stride.analytics.logEvent(name: "SWIPE_SIZE_TOGGLE_OFF");
    }
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        hideSkip: true,
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout() {
    Future.delayed(Duration(milliseconds: 500), () {
      showTutorial();
    });
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: rulerButton,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "줄자 버튼",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상품의 사이즈를 확인할 수 있습니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: buyButton,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "구매 버튼",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "쇼핑몰로 이동할 수 있습니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: sizeToggle,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "사이즈 스위치",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "스위치가 켜지면 설정한 사이즈에 맞는 옷만 볼 수 있습니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var configService = Provider.of<ConfigService>(context, listen: false);
    var swipeService = Provider.of<SwipeService>(context, listen: false);
    var dressService = Provider.of<DressRoomService>(context, listen: false);
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    var lookService = Provider.of<LookBookService>(context, listen: false);

    return BaseWidget<SwipeModel>(
        model: SwipeModel(dressService, swipeService),
        builder: (context, model, child) {
          if (swipeService.init == false) {
            if (dressService.init == false) {
              dressService.getDressRoom();
            }
            if (lookService.init == false) {
              lookService.getLookBook();
            }
            model.initCards();
            return LoadingWidget();
          } else if (model.busy)
            return FadeIn(delay: 0.5, child: (LoadingWidget()));

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if ((configService.currentVersion != configService.updateVersion) &&
                !configService.alreadyShow) {
              ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
                duration: Duration(milliseconds: 1500),
                content: Text('Stride앱의 최신 버전이 나왔습니다!'),
              ));
              configService.alreadyShow = true;
            }
            if (authService.swipe_tutorial == false) {
              authService.swipe_tutorial = true;
              var _storage = authService.storage;
              _storage.write(key: 'swipe_tutorial', value: 'true');
              _afterLayout();
            }
          });

          return FadeIn(
            delay: 0.3,
            child: Stack(children: [
              Align(
                alignment: Alignment.topCenter,
                child: clothTypeBar(model, context),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  buttonRow(
                      model,
                      () => onTapDislikeButton(model),
                      () => onTapPurchaseButton(model),
                      () => onTapLikeButton(model),
                      buyButton),
                  UIHelper.verticalSpaceSmall,
                  // Transform.scale(
                  //   key: sizeToggle,
                  //   scale: 1.5,
                  //   child: Switch(
                  //     value: size_flag,
                  //     onChanged: (value) => onTapSizeButton(model, value),
                  //     activeColor: backgroundColor,
                  //   ),
                  // ),
                  UIHelper.verticalSpaceSmall,
                ]),
              ),
              SwipeCardSection(
                  context,
                  model,
                  rulerButton,
                  () => onTapDislikeButton(model),
                  () => onTapLikeButton(model)),
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
}
