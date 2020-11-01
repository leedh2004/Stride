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
      rulerButton = GlobalKey(),
      filterButton = GlobalKey();
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
            padding: EdgeInsets.all(8), child: Text('해당 상품이 드레스룸에 추가되었습니다.')),
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

  void showTutorial(BuildContext context) {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        hideSkip: true,
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      var authService =
          Provider.of<AuthenticationService>(context, listen: false);
      var _storage = authService.storage;
      _storage.write(key: 'swipe_tutorial', value: 'true');
      authService.swipe_tutorial = true;
      setState(() {});
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(context) {
    Future.delayed(Duration(milliseconds: 500), () {
      showTutorial(context);
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
                      "쇼핑몰 페이지 이동",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "해당 쇼핑몰로 이동하여 상품을 살펴보고 구매할 수 있습니다",
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
                      "상세 정보 보기",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상품의 이름을 클릭해 사이즈, 색상, 컨셉 등을\n 빠르게 확인할 수 있습니다",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 40),
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
                      "'좋아요'보다 더 마음에 드는, 정말 사고 싶은 옷을 발견했다면? ⭐️ 을 눌러서 '좋아요'를 표시하는 동시에 컬렉션에 모아보세요!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "나만의 옷장에 저장하고 어울리는 옷을 모아 상하의 코디를 맞춰보고 룩북으로  기록할 수 있습니다",
                        style: TextStyle(fontSize: 14, color: Colors.black),
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
        identify: "Target 3",
        keyTarget: filterButton,
        color: Colors.white,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "필터 설정",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "내가 찾고 싶은 아이템이 보이지 않는다면?\n원하는 카테고리, 컨셉, 사이즈, 가격, 컬러에 맞춘 아이템을 필터로 검색해보세요!",
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

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if ((configService.currentVersion != configService.updateVersion) &&
                !configService.alreadyShow) {
              ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
                duration: Duration(milliseconds: 1500),
                content: Text('Stride앱의 최신 버전이 나왔습니다!'),
              ));
              configService.alreadyShow = true;
            }
            if (authService.swipe_tutorial == false) {
              _afterLayout(context);
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
                padding: EdgeInsets.only(right: 25, top: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    key: filterButton,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FilterBar(model, context);
                      }));
                    },
                    child: Image.asset(
                      'assets/filter.png',
                      width: 50,
                      height: 50,
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
