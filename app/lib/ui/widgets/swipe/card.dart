import 'dart:math';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/swipe/card_align.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 0.0),
  Alignment(0.0, 0.0),
  Alignment(0.0, 0.0)
];

List<Size> cardsSize = List(3);

class SwipeCardSection extends StatefulWidget {
  SwipeModel model;
  SwipeCardSection(BuildContext context, SwipeModel _model) {
    model = _model;
    cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.65);
    cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
  }
  @override
  _SwipeCardSectionState createState() => _SwipeCardSectionState();
}

class _SwipeCardSectionState extends State<SwipeCardSection>
    with SingleTickerProviderStateMixin {
  List<SwipeCardAlignment> cards = List();
  AnimationController _controller;
  int index = 0;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;
  List<double> _opacity = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    print("init!!!");
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
    frontCardAlign = cardsAlign[2];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        backCard(context),
        middleCard(context),
        frontCard(context),
        nopeTextWidget(),
        passTextWidget(),
        likeTextWidget(),
        if (_controller.status != AnimationStatus.forward)
          SizedBox.expand(
              child: Container(
            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: GestureDetector(
              // behavior: HitTestBehavior.deferToChild,
              onLongPress: () {
                // showGeneralDialog(
                //   context: context,
                //   barrierColor:
                //       Colors.black12.withOpacity(0.6), // background color
                //   barrierDismissible:
                //       false, // should dialog be dismissed when tapped outside
                //   barrierLabel: "Dialog", // label for barrier
                //   transitionDuration: Duration(
                //       milliseconds:
                //           400), // how long it takes to popup dialog after button click
                //   pageBuilder: (_, __, ___) {
                //     // your widget implementation
                //     return SizeDialog(Provider.of<SwipeModel>(context)
                //             .items[widget.model.type]
                //         [(widget.model.index[widget.model.type])]);
                //   },
                // );
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (___, _, __) => SizeDialog(
                        Provider.of<SwipeService>(context)
                            .items[widget.model.type][(widget.model.index)])));
              },
              onTap: () {
                setState(() {
                  index++;
                });
              },
              onTapUp: (details) {
                print(details.globalPosition.dy);
              },
              // While dragging the first card
              onPanUpdate: (DragUpdateDetails details) {
                // Add what the user swiped in the last frame to the alignment of the card
                List<double> opacity = [0, 0, 0];
                if (frontCardAlign.x > START_RIGHT) {
                  // See Heart Icon applying Opacity
                  opacity[LIKE] = frontCardAlign.x / OPACITY_SPEED;
                  if (opacity[LIKE] >= MAX_OPACITY) opacity[LIKE] = MAX_OPACITY;
                } else if (frontCardAlign.x < START_LEFT) {
                  // See Broken Heart Icon applying Opacity
                  opacity[HATE] = -frontCardAlign.x / OPACITY_SPEED;
                  if (opacity[HATE] >= MAX_OPACITY) opacity[HATE] = MAX_OPACITY;
                } else if (frontCardAlign.y < START_UP) {
                  // See Pass Icon applying Opacity
                  opacity[PASS] = -(frontCardAlign.y / OPACITY_SPEED);
                  if (opacity[PASS] >= MAX_OPACITY) opacity[PASS] = MAX_OPACITY;
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
                String type = Provider.of<SwipeService>(context).type;
                int index = Provider.of<SwipeService>(context).index[type];
                SwipeCard item =
                    Provider.of<SwipeService>(context).items[type][index];
                setState(() {
                  _opacity[HATE] = 0.0;
                  _opacity[LIKE] = 0.0;
                  _opacity[PASS] = 0.0;
                });
                // Send result reqeust to server
                if (frontCardAlign.x > STANDARD_RIGHT) {
                  Stride.analytics.logEvent(name: 'LIKE', parameters: {
                    'itemId': item.product_id.toString(),
                    'itemName': item.product_name,
                    'itemCategory': item.shop_mall
                  });
                  widget.model.likeRequest();
                  animateCards();
                } else if (frontCardAlign.x < STANDARD_LEFT) {
                  Stride.analytics.logEvent(name: 'DISLIKE', parameters: {
                    'itemId': item.product_id.toString(),
                    'itemName': item.product_name,
                    'itemCategory': item.shop_mall
                  });
                  widget.model.dislikeRequest();
                  animateCards();
                } else if (frontCardAlign.y < STANDARD_UP) {
                  widget.model.passRequest();
                  Stride.analytics.logEvent(name: 'PASS', parameters: {
                    'itemId': item.product_id.toString(),
                    'itemName': item.product_name,
                    'itemCategory': item.shop_mall
                  });
                  animateCards();
                } else {
                  // Return to the initial rotation and alignment
                  setState(() {
                    frontCardAlign = defaultFrontCardAlign;
                    frontCardRot = 0.0;
                  });
                }
              },
            ),
          ))
        else
          Container(),
        //RulerWidget()
      ],
    ));
  }

  Widget RulerWidget() {
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
                  icon: FaIcon(
                    FontAwesomeIcons.rulerVertical,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    var item = Provider.of<SwipeService>(context, listen: false)
                        .items[widget.model.type][(widget.model.index)];
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
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     border: Border.all(color: greenColor, width: 5)),
                    child: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      size: 100,
                      color: pinkColor,
                    )
                    // Text(
                    //   'LIKE',
                    //   style: greenHeaderStyle,
                    // ),
                    ),
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
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     border: Border.all(color: pinkColor, width: 5)),
                    child: FaIcon(
                      FontAwesomeIcons.times,
                      size: 100,
                      color: Colors.lightBlueAccent,
                    )

                    // Text(
                    //   'NOPE',
                    //   style: redHeaderStyle,
                    // ),
                    ),
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
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     border: Border.all(color: Colors.white, width: 5)),
                    child: FaIcon(
                      FontAwesomeIcons.chevronCircleUp,
                      size: 100,
                      color: Colors.white,
                    )
                    // Text(
                    //   'PASS',
                    //   style: whiteHeaderStyle,
                    // ),
                    ),
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

  Widget frontCard(BuildContext context) {
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
              size: cardsSize[0], child: SwipeCardAlignment(item, index)),
        ));
  }

  void changeCardsOrder() {
    widget.model.nextItem();
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      // var temp = cards[0];
      // cards[0] = cards[1];
      // cards[1] = cards[2];
      // cards[2] = temp;
      // cards[2] = SwipeCardAlignment(cardsCounter);
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
}

class CardsAnimation {
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
    if (beginAlign.x < 3 && beginAlign.x > -3) {
      return AlignmentTween(
              begin: beginAlign,
              end: Alignment(
                  0.0, beginAlign.y - 30) // Has swiped to the left or right?
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
