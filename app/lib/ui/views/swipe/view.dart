import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:app/ui/widgets/filter/concept.dart';
import 'package:app/ui/widgets/filter/price.dart';
import 'package:app/ui/widgets/filter/size.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/button_row.dart';
import 'package:app/ui/widgets/filter/color.dart';
import 'package:app/ui/widgets/swipe/card_gesture.dart';
import 'package:app/ui/widgets/swipe/filter_bar.dart';
import 'package:app/ui/widgets/swipe/image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../base_widget.dart';
import '../service_view.dart';

class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  //TabController tabController;
  bool size_flag = false, onflag = false;
  double like_opacity = 0, dislike_opacity = 0;
  GlobalKey collectionButton = GlobalKey(),
      buyButton2 = GlobalKey(),
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

  onTapCollectButton(SwipeModel model) async {
    RecentItem item =
        Provider.of<SwipeService>(context, listen: false).items[model.index];
    model.addItem(item);
    ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Row(children: [
        Image.asset('assets/purple_star.png', width: 30),
        Padding(
            padding: EdgeInsets.all(8), child: Text('해당 상품이 콜렉션에 추가되었습니다.')),
      ]),
    ));

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
        identify: "Target 2",
        keyTarget: buyButton2,
        color: Colors.white,
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
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상품을 구매할 수 있습니다",
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
        identify: "Target 1",
        keyTarget: rulerButton,
        color: Colors.white,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "자세히 보기 버튼",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상품의 사이즈, 색상, 컨셉 등을\n 빠르게 확인할 수 있습니다",
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
        keyTarget: collectionButton,
        color: Colors.white,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "콜렉션 버튼",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "마음에 드는 상품을 저장할 수 있습니다",
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
    var lookService = Provider.of<LookBookService>(context, listen: false);
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    // var lookService = Provider.of<LookBookService>(context, listen: false);

    return BaseWidget<SwipeModel>(
        model: SwipeModel(swipeService, dressService, authService),
        builder: (context, model, child) {
          if (swipeService.init == false) {
            if (dressService.init == false) {
              dressService.getDressRoom();
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
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: FilterBar(model, context),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(32, 16, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/stride_text_logo.png',
                    width: 100,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FilterBar(model, context);
                      }));
                    },
                    child: Image.asset(
                      'images/filter.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  buttonRow(
                      model,
                      () => onTapDislikeButton(model),
                      () => onTapCollectButton(model),
                      () => onTapLikeButton(model),
                      collectionButton),
                ]),
              ),
              SwipeCardSection(
                  context,
                  model,
                  rulerButton,
                  buyButton2,
                  () => onTapDislikeButton(model),
                  () => onTapLikeButton(model),
                  () => onTapCollectButton(model)),
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: dislike_opacity,
                  child: Align(
                      alignment: Alignment.center, child: dislikeImageWidget()),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: like_opacity,
                  child: Align(
                      alignment: Alignment.center, child: heartImageWidget()),
                ),
              ),
            ]),
          );
        });
  }
}
