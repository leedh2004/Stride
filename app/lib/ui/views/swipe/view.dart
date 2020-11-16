import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/swipe/tutorial.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/button_row.dart';
import 'package:app/ui/widgets/swipe/card_gesture.dart';
import 'package:app/ui/widgets/swipe/filter_bar.dart';
import 'package:app/ui/widgets/swipe/image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';

class SwipeView extends StatefulWidget {
  SwipeView(this.tutorialRestart);
  Function tutorialRestart;
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
  // TutorialCoachMark tutorialCoachMark;
  // List<TargetFocus> targets = List();

  @override
  void initState() {
    // initTargets();
    super.initState();
  }

  onTapDislikeButton(SwipeModel model) async {
    if (onflag) return false;
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    if (authService.flush_tutorial == WAIT_SWIPE_BUTTON)
      flushList[4].dismiss(false);
    onflag = true;
    Stride.logEvent(name: 'SWIPE_HATE_BUTTON_CLICKED');
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
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    RecentItem item =
        Provider.of<SwipeService>(context, listen: false).items[model.index];
    if (authService.flush_tutorial >= 0) {
      if (authService.flush_tutorial == WAIT_COLLECTION_BUTTON)
        flushList[8].dismiss(true);
      else
        return;
    }
    model.addItem(item);
    collection_flush.show(context);
    if (onflag) return false;
    Stride.logEvent(name: 'SWIPE_COLLECT_BUTTON_CLICKED');
    onflag = true;
    model.collectRequest();
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
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    if (authService.flush_tutorial == WAIT_SWIPE_BUTTON)
      flushList[4].dismiss(true);
    Stride.logEvent(name: 'SWIPE_LIKE_BUTTON_CLICKED');
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

  @override
  Widget build(BuildContext context) {
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

          // WidgetsBinding.instance.addPostFrameCallback((_) async {
          //   if ((configService.currentVersion != configService.updateVersion) &&
          //       !configService.alreadyShow) {
          //     new_version_flush.show(context);
          //     configService.alreadyShow = true;
          //   }
          //   // if (authService.flush_tutorial == 0 &&
          //   // authService.onTutorial == false) {
          //   showTutorial(context);
          //   // authService.onTutorial = true;
          //   // }
          // });

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
                  padding: EdgeInsets.only(left: 132, top: 16),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          if (authService.flush_tutorial >= 0) {
                            // disable_flush.show(context);
                            return;
                          }
                          Stride.logEvent(
                              name: "SWIPE_TUTORIAL_RESTART_BUTTON_CLICKED");

                          widget.tutorialRestart();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: FaIcon(
                            FontAwesomeIcons.questionCircle,
                            size: 15,
                          ),
                        ),
                      ))),
              Padding(
                padding: EdgeInsets.only(right: 25, top: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    key: filterButton,
                    onTap: () async {
                      Stride.logEvent(name: "SWIPE_FILTER_BUTTON_CLICKED");
                      if (authService.flush_tutorial >= 0) {
                        if (authService.flush_tutorial == WAIT_FILTER_BUTTON) {
                          flushList2[3].dismiss(true);
                        } else {
                          // disable_flush.show(context);
                          return;
                        }
                      }

                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FilterBar(model, context);
                      }));
                      if (authService.flush_tutorial == WAIT_FILTER_BUTTON) {
                        Stride.logEvent(name: "TUTORIAL_END");
                        authService.storage
                            .write(key: 'flush_tutorial', value: 'true');
                        authService.flush_tutorial = -1;
                        await flushList2[5].show(context);
                        await flushList2[6].show(context);
                      }
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
