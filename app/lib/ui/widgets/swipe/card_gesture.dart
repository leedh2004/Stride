import 'dart:math';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/views/swipe/info.dart';
import 'package:app/ui/widgets/swipe/card_align.dart';
import 'package:app/ui/widgets/swipe/image.dart';
import 'package:app/ui/widgets/swipe/no_swipe_view.dart';
import 'package:app/ui/widgets/swipe/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'card_animation.dart';

Alignment align = Alignment.center;

List<Alignment> cardsAlign = [
  Alignment(0, -0.4),
  Alignment(0, -0.2),
  Alignment(0, 0)
];

List<Size> cardsSize = List(3);

class SwipeCardSection extends StatefulWidget {
  SwipeModel model;
  GlobalKey rulerButton, buyButton;
  Function onTapDislikeButton, onTapLikeButton, onTapCollectionButton;

  SwipeCardSection(
      BuildContext context,
      SwipeModel _model,
      GlobalKey _rulerButton,
      GlobalKey _buyButton,
      Function _onTapDislikeButton,
      Function _onTapLikeButton,
      Function _onTapCollectionButton) {
    model = _model;
    rulerButton = _rulerButton;
    buyButton = _buyButton;

    double standard = 0.61;
    if (MediaQuery.of(context).size.height > 800) standard = 0.65;

    cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.88,
        MediaQuery.of(context).size.height * (standard));
    cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.83,
        MediaQuery.of(context).size.height * (standard));
    cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.78,
        MediaQuery.of(context).size.height * (standard));

    onTapDislikeButton = _onTapDislikeButton;
    onTapLikeButton = _onTapLikeButton;
    onTapCollectionButton = _onTapCollectionButton;
  }
  @override
  _SwipeCardSectionState createState() => _SwipeCardSectionState();
}

class _SwipeCardSectionState extends State<SwipeCardSection>
    with SingleTickerProviderStateMixin {
  List<SwipeCardAlignment> cards = List();
  AnimationController _controller;

  Tween<Alignment> _tween = Tween(begin: cardsAlign[2], end: cardsAlign[0]);
  Animation _animation;

  int tutorial_like = 0;

  int index = 0;
  bool move_flag = false;
  bool left_effect = false;
  bool right_effect = false;

  final Alignment defaultFrontCardAlign = align;
  Alignment frontCardAlign;

  double frontCardRot = 0.0;
  List<double> _opacity = [0, 0];

  @override
  void initState() {
    super.initState();
    frontCardAlign = cardsAlign[2];
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (move_flag)
          changeCardsOrder();
        else {
          setState(() {
            frontCardAlign = defaultFrontCardAlign;
            frontCardRot = 0.0;
          });
        }
      }
    });
  }

  void changeCardsOrder() {
    widget.model.nextItem();
    setState(() {
      index = 0;
      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  Widget backCard(BuildContext context) {
    if (Provider.of<SwipeService>(context).items.length <=
        widget.model.index + 2) {
      return Container();
    }

    RecentItem item =
        Provider.of<SwipeService>(context).items[(widget.model.index) + 2];

    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller, frontCardAlign)
              .value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller, frontCardAlign)
                  .value
              : cardsSize[2],
          child: SwipeCardAlignment(item, 0)),
    );
  }

  Widget middleCard(BuildContext context) {
    if (Provider.of<SwipeService>(context).items.length <=
        widget.model.index + 1) {
      return Container();
    }
    RecentItem item =
        Provider.of<SwipeService>(context).items[(widget.model.index) + 1];

    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller, frontCardAlign)
              .value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller, frontCardAlign)
                  .value
              : cardsSize[1],
          child: SwipeCardAlignment(item, 0)),
    );
  }

  Widget frontCard(BuildContext context, SwipeModel model) {
    //int idx = Provider.of<SwipeService>(context).curIdx;
    if (Provider.of<SwipeService>(context).items.length <= widget.model.index) {
      return NoSwipeView();
    }

    RecentItem item =
        Provider.of<SwipeService>(context).items[(widget.model.index)];

    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(
              size: cardsSize[0],
              child: SwipeCardAlignment(item, model.image_index)),
        ));
  }

  Widget leftfrontCard(BuildContext context, SwipeModel model) {
    //int idx = Provider.of<SwipeService>(context).curIdx;

    if (Provider.of<SwipeService>(context).items.length <= widget.model.index) {
      return NoSwipeView();
    }

    RecentItem item =
        Provider.of<SwipeService>(context).items[(widget.model.index)];
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: pi),
        duration: const Duration(milliseconds: 100),
        onEnd: () {
          setState(() {
            left_effect = false;
          });
        },
        builder: (context, value, __) {
          return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(sin(value) * 0.1),
              child: Align(
                  alignment: _controller.status == AnimationStatus.forward
                      ? CardsAnimation.frontCardDisappearAlignmentAnim(
                              _controller, frontCardAlign)
                          .value
                      : frontCardAlign,
                  child: Transform.rotate(
                    angle: (pi / 180.0) * frontCardRot,
                    child: SizedBox.fromSize(
                        size: cardsSize[0],
                        child: SwipeCardAlignment(item, model.image_index)),
                  )));
        });
  }

  Widget rightfrontCard(BuildContext context, SwipeModel model) {
    //int idx = Provider.of<SwipeService>(context).curIdx;
    if (Provider.of<SwipeService>(context).items.length <= widget.model.index) {
      return NoSwipeView();
    }

    RecentItem item =
        Provider.of<SwipeService>(context).items[(widget.model.index)];
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: pi),
        duration: const Duration(milliseconds: 100),
        onEnd: () {
          setState(() {
            right_effect = false;
          });
        },
        builder: (context, value, __) {
          return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(sin(value) * -0.1),
              child: Align(
                  alignment: _controller.status == AnimationStatus.forward
                      ? CardsAnimation.frontCardDisappearAlignmentAnim(
                              _controller, frontCardAlign)
                          .value
                      : frontCardAlign,
                  child: Transform.rotate(
                    angle: (pi / 180.0) * frontCardRot,
                    child: SizedBox.fromSize(
                        size: cardsSize[0],
                        child: SwipeCardAlignment(item, model.image_index)),
                  )));
        });
  }

  Widget shoppingWidget(SwipeModel model, Function onTapDislikeButton,
      Function onTapLikeButton, Function onTapCollectionButton) {
    String item = Provider.of<SwipeService>(context)
        .items[(widget.model.index)]
        .product_name;

    return Align(
        alignment: frontCardAlign,
        child: SizedBox.fromSize(
          size: cardsSize[0],
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                width: double.infinity,
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        key: widget.rulerButton,
                        onTap: () async {
                          final result = await Navigator.push(context,
                              MaterialPageRoute<String>(
                                  builder: (BuildContext context) {
                            return DetailInfo(model);
                          }));
                          if (await result == 'like') {
                            onTapLikeButton();
                            tutorial_like++;
                          } else if (await result == 'dislike') {
                            onTapDislikeButton();
                          } else if (await result == 'collect') {
                            onTapCollectionButton();
                          }
                        },
                        child: Opacity(
                          opacity: 0,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                              child: Text(item)),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        key: widget.buyButton,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            RecentItem item = Provider.of<SwipeService>(context)
                                .items[model.index];
                            Stride.analytics.logEvent(
                                name: 'SWIPE_PURCHASE_BUTTON_CLICKED',
                                parameters: {
                                  'itemId': item.product_id.toString(),
                                  'itemName': item.product_name,
                                  'itemCategory': item.shop_name
                                });

                            model.purchaseItem(item.product_id);
                            return ProductWebView(
                                item.product_url, item.shop_name);
                          }));
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // child: Align(
          //   alignment: Alignment.bottomRight,
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
          //           child: IconButton(
          //             key: widget.buyButton,
          //             icon: Container(
          //               width: 50,
          //               height: 50,
          //               decoration: BoxDecoration(
          //                   color: Colors.transparent,
          //                   borderRadius: BorderRadius.circular(25)),
          //               child: Center(
          //                 child: FaIcon(FontAwesomeIcons.shoppingCart,
          //                     size: 15, color: Colors.transparent),
          //               ),
          //             ),
          //             onPressed: () {
          //               Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) {
          //                 RecentItem item = Provider.of<SwipeService>(context)
          //                     .items[model.index];
          //                 Stride.analytics.logEvent(
          //                     name: 'SWIPE_PURCHASE_BUTTON_CLICKED',
          //                     parameters: {
          //                       'itemId': item.product_id.toString(),
          //                       'itemName': item.product_name,
          //                       'itemCategory': item.shop_name
          //                     });

          //                 model.purchaseItem(item.product_id);
          //                 return ProductWebView(
          //                     item.product_url, item.shop_name);
          //               }));
          //             },
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.fromLTRB(0, 0, 25, 20),
          //           child: IconButton(
          //             key: widget.rulerButton,
          //             icon: Container(
          //               width: 50,
          //               height: 50,
          //               decoration: BoxDecoration(
          //                   color: Colors.transparent,
          //                   borderRadius: BorderRadius.circular(25)),
          //               child: Center(
          //                 child: FaIcon(FontAwesomeIcons.info,
          //                     size: 15, color: Colors.transparent),
          //               ),
          //             ),
          //             onPressed: () async {
          //               final result = await Navigator.push(context,
          //                   MaterialPageRoute<String>(
          //                       builder: (BuildContext context) {
          //                 return DetailInfo(model);
          //               }));
          //               if (await result == 'like') {
          //                 onTapLikeButton();
          //                 tutorial_like++;
          //               } else if (await result == 'dislike') {
          //                 onTapDislikeButton();
          //               } else if (await result == 'collect') {
          //                 onTapCollectionButton();
          //               }
          //             },
          //           ),
          //         ),
          //       ]),
          // ),
        ));
  }

  Widget likeOpactiyWidget() {
    if (Provider.of<SwipeService>(context).items.length <= widget.model.index) {
      return Container();
    }
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(
            size: cardsSize[0],
            child: Opacity(opacity: _opacity[LIKE], child: heartImageWidget()),
          ),
        ));
  }

  Widget dislikeOpacityWidget() {
    if (Provider.of<SwipeService>(context).items.length <= widget.model.index) {
      return Container();
    }
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(
            size: cardsSize[0],
            child:
                Opacity(opacity: _opacity[HATE], child: dislikeImageWidget()),
          ),
        ));
  }

  void after_tutorial(AuthenticationService authService) {
    if (tutorial_like == 5 && authService.swipe_heart_tutorial == false) {
      authService.swipe_heart_tutorial = true;
      tutorial_like++;
      var _storage = authService.storage;
      _storage.write(key: 'swipe_heart_tutorial', value: 'true');

      ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 3000),
        backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Row(children: [
          Image.asset('assets/purple_star.png', width: 30),
          Padding(
              padding: EdgeInsets.all(8),
              child: Text('사진의 좌우 영역을 탭해서\n 상품 상세이미지를 확인할 수 있습니다!')),
        ]),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => after_tutorial(authService));
    return Stack(
      children: <Widget>[
        backCard(context),
        middleCard(context),
        left_effect
            ? leftfrontCard(context, widget.model)
            : right_effect
                ? rightfrontCard(context, widget.model)
                : frontCard(context, widget.model),
        dislikeOpacityWidget(),
        likeOpactiyWidget(),
        tutorial_like < 5 &&
                authService.swipe_heart_tutorial == false &&
                authService.swipe_tutorial == true
            ? tutorialTextWidget(tutorial_like)
            : Container(),
        _controller.status != AnimationStatus.forward
            ? Align(
                alignment: cardsAlign[0],
                child: SizedBox(
                    width: cardsSize[0].width,
                    height: cardsSize[0].height,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: GestureDetector(
                        // excludeFromSemantics: true,
                        onPanStart: (details) {
                          print('start!');
                        },
                        onPanUpdate: (DragUpdateDetails details) {
                          List<double> opacity = [0, 0];

                          if (frontCardAlign.x > 0) {
                            opacity[LIKE] = frontCardAlign.x / OPACITY_SPEED;
                            if (opacity[LIKE] >= MAX_OPACITY)
                              opacity[LIKE] = MAX_OPACITY;
                          } else if (frontCardAlign.x < 0) {
                            opacity[HATE] = -frontCardAlign.x / OPACITY_SPEED;
                            if (opacity[HATE] >= MAX_OPACITY)
                              opacity[HATE] = MAX_OPACITY;
                          }
                          setState(() {
                            // Set Opacity
                            _opacity[LIKE] = opacity[LIKE];
                            _opacity[HATE] = opacity[HATE];
                            // Drag Card SPEED
                            frontCardAlign = Alignment(
                                frontCardAlign.x +
                                    X_SPEED *
                                        details.delta.dx /
                                        MediaQuery.of(context).size.width,
                                frontCardAlign.y +
                                    Y_SPEED *
                                        details.delta.dy /
                                        MediaQuery.of(context).size.height);
                            frontCardRot = frontCardAlign.x;
                          });
                        },
                        // When releasing the first card
                        onPanEnd: (_) {
                          // If the front card was swiped far enough to count as swiped
                          // String type =
                          //     Provider.of<SwipeService>(context, listen: false)
                          //         .type;
                          int index =
                              Provider.of<SwipeService>(context, listen: false)
                                  .index;
                          RecentItem item =
                              Provider.of<SwipeService>(context, listen: false)
                                  .items[index];
                          setState(() {
                            _opacity[HATE] = 0.0;
                            _opacity[LIKE] = 0.0;
                          });
                          // Send result reqeust to server
                          if (frontCardAlign.x > STANDARD_RIGHT) {
                            tutorial_like++;
                            move_flag = true;
                            Stride.analytics
                                .logEvent(name: 'LIKE', parameters: {
                              'itemId': item.product_id.toString(),
                              'itemName': item.product_name,
                              'itemCategory': item.shop_name
                            });
                            widget.model.likeRequest();
                            animateCards();
                          } else if (frontCardAlign.x < STANDARD_LEFT) {
                            move_flag = true;
                            Stride.analytics
                                .logEvent(name: 'DISLIKE', parameters: {
                              'itemId': item.product_id.toString(),
                              'itemName': item.product_name,
                              'itemCategory': item.shop_name
                            });
                            widget.model.dislikeRequest();
                            animateCards();
                          } else {
                            move_flag = false;
                            animateCards();
                          }
                        },
                        onTapUp: (details) {
                          double standard =
                              MediaQuery.of(context).size.width / 2;
                          if (standard < details.globalPosition.dx) {
                            if (!widget.model.nextImage()) {
                              setState(() {
                                right_effect = true;
                                HapticFeedback.mediumImpact();
                              });
                            }
                          } else {
                            if ((!widget.model.prevImage())) {
                              setState(() {
                                left_effect = true;
                                HapticFeedback.mediumImpact();
                              });
                            }
                          }
                          // animateCards();
                        },
                      ),
                    )),
              )
            : Container(),
        shoppingWidget(widget.model, widget.onTapDislikeButton,
            widget.onTapLikeButton, widget.onTapCollectionButton),
        // shoppingWidget(widget.model),
      ],
    );
  }
}
