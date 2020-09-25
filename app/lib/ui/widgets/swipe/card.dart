import 'dart:math';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/swipe/info.dart';
import 'package:app/ui/widgets/swipe/card_align.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Alignment align = Alignment.center + Alignment(0, -0.8);
List<Alignment> cardsAlign = [align, align, align];
List<Size> cardsSize = List(3);

class SwipeCardSection extends StatefulWidget {
  SwipeModel model;
  GlobalKey rulerButton;
  Function onTapDislikeButton, onTapLikeButton;
  SwipeCardSection(
      BuildContext context,
      SwipeModel _model,
      GlobalKey _rulerButton,
      Function _onTapDislikeButton,
      Function _onTapLikeButton) {
    model = _model;
    rulerButton = _rulerButton;
    double standard = 0.7;
    if (MediaQuery.of(context).size.height > 800) standard = 0.75;
    cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * (standard + 0.05));
    cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * standard);
    cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * standard);
    onTapDislikeButton = _onTapDislikeButton;
    onTapLikeButton = _onTapLikeButton;
  }
  @override
  _SwipeCardSectionState createState() => _SwipeCardSectionState();
}

class _SwipeCardSectionState extends State<SwipeCardSection>
    with SingleTickerProviderStateMixin {
  List<SwipeCardAlignment> cards = List();
  AnimationController _controller;
  Animation _animation;
  int index = 0;
  bool move_flag = false;

  final Alignment defaultFrontCardAlign = align;
  Alignment frontCardAlign;

  double frontCardRot = 0.0;
  List<double> _opacity = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    frontCardAlign = cardsAlign[0];
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backCard(context),
        middleCard(context),
        frontCard(context, widget.model),
        nopeTextWidget(),
        passTextWidget(),
        likeTextWidget(),
        if (_controller.status != AnimationStatus.forward)
          Align(
            alignment: cardsAlign[0],
            child: SizedBox(
                width: cardsSize[0].width,
                height: cardsSize[0].height,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(pi * CardsAnimation.test(_controller).value),
                    child: GestureDetector(
                      onTapUp: (details) {
                        double standard = MediaQuery.of(context).size.width / 2;
                        if (standard < details.globalPosition.dx) {
                          widget.model.nextImage();
                        } else {
                          widget.model.prevImage();
                        }
                        // animateCards();
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        List<double> opacity = [0, 0, 0];

                        if (frontCardAlign.x > START_RIGHT) {
                          opacity[LIKE] = frontCardAlign.x / OPACITY_SPEED;
                          if (opacity[LIKE] >= MAX_OPACITY)
                            opacity[LIKE] = MAX_OPACITY;
                        } else if (frontCardAlign.x < START_LEFT) {
                          opacity[HATE] = -frontCardAlign.x / OPACITY_SPEED;
                          if (opacity[HATE] >= MAX_OPACITY)
                            opacity[HATE] = MAX_OPACITY;
                        } else if (frontCardAlign.y < START_UP) {
                          opacity[PASS] = -(frontCardAlign.y / OPACITY_SPEED);
                          if (opacity[PASS] >= MAX_OPACITY)
                            opacity[PASS] = MAX_OPACITY;
                        }
                        // Rendering View
                        setState(() {
                          // Set Opacity
                          _opacity[LIKE] = opacity[LIKE];
                          _opacity[HATE] = opacity[HATE];
                          _opacity[PASS] = opacity[PASS];
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
                        String type =
                            Provider.of<SwipeService>(context, listen: false)
                                .type;
                        int index =
                            Provider.of<SwipeService>(context, listen: false)
                                .index[type];
                        SwipeCard item =
                            Provider.of<SwipeService>(context, listen: false)
                                .items[type][index];
                        setState(() {
                          _opacity[HATE] = 0.0;
                          _opacity[LIKE] = 0.0;
                          _opacity[PASS] = 0.0;
                        });
                        // Send result reqeust to server
                        if (frontCardAlign.x > STANDARD_RIGHT) {
                          move_flag = true;
                          Stride.analytics.logEvent(name: 'LIKE', parameters: {
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
                        } else if (frontCardAlign.y < STANDARD_UP) {
                          move_flag = true;
                          widget.model.passRequest();
                          Stride.analytics.logEvent(name: 'PASS', parameters: {
                            'itemId': item.product_id.toString(),
                            'itemName': item.product_name,
                            'itemCategory': item.shop_name
                          });
                          animateCards();
                        } else {
                          // Return to the initial rotation and alignment
                          move_flag = false;
                          animateCards();
                        }
                      },
                    ),
                  ),
                )),
          )
        else
          Container(),
        rulerWidget(
            widget.model, widget.onTapDislikeButton, widget.onTapLikeButton),
      ],
    );
  }

  Widget rulerWidget(
      SwipeModel model, Function onTapDislikeButton, Function onTapLikeButton) {
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
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                child: IconButton(
                  key: widget.rulerButton,
                  icon: FaIcon(
                    FontAwesomeIcons.rulerVertical,
                    size: 50,
                    color: Colors.transparent,
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(context,
                        MaterialPageRoute<String>(
                            builder: (BuildContext context) {
                      return DetailInfo(model);
                    }));
                    if (await result == 'like') {
                      onTapLikeButton();
                    } else if (await result == 'dislike') {
                      onTapDislikeButton();
                    }
                  },
                ),
              ),
            ),
          ),
        ));
  }

  Widget likeTextWidget() {
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
            child: Opacity(
              opacity: _opacity[LIKE],
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
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
          ),
        ));
  }

  Widget nopeTextWidget() {
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
            child: Opacity(
              opacity: _opacity[HATE],
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
                alignment: Alignment.center,
                child: Container(
                    padding: EdgeInsets.all(3),
                    child: FaIcon(
                      FontAwesomeIcons.times,
                      size: 100,
                      color: Colors.blue,
                    )),
              ),
            ),
          ),
        ));
  }

  Widget passTextWidget() {
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
            child: Opacity(
              opacity: _opacity[PASS],
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                alignment: Alignment.center,
                child: Container(
                    padding: EdgeInsets.all(3),
                    child: Image.asset(
                      'images/up-arrow.png',
                      width: 100,
                    )),
              ),
            ),
          ),
        ));
  }

  Widget backCard(BuildContext context) {
    SwipeCard item = Provider.of<SwipeService>(context).items[widget.model.type]
        [(widget.model.index) + 2];

    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: SwipeCardAlignment(item, 0)),
    );
  }

  Widget middleCard(BuildContext context) {
    SwipeCard item = Provider.of<SwipeService>(context).items[widget.model.type]
        [(widget.model.index) + 1];

    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: SwipeCardAlignment(item, 0)),
    );
  }

  Widget frontCard(BuildContext context, SwipeModel model) {
    //int idx = Provider.of<SwipeService>(context).curIdx;
    SwipeCard item = Provider.of<SwipeService>(context).items[widget.model.type]
        [(widget.model.index)];

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
}

class CardsAnimation {
  static Animation test(parent) {
    print('!!!!!!!');
    return Tween(begin: 0, end: 1).animate(CurvedAnimation(
        parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x < STANDARD_RIGHT && beginAlign.x > STANDARD_LEFT) {
      if (beginAlign.y > STANDARD_UP) {
        return AlignmentTween(begin: beginAlign, end: align).animate(
            CurvedAnimation(
                parent: parent,
                curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
      }
      return AlignmentTween(
              begin: beginAlign,
              end: Alignment(
                  0.0, beginAlign.y - 20) // Has swiped to the left or right?
              )
          .animate(CurvedAnimation(
              parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
    }
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
