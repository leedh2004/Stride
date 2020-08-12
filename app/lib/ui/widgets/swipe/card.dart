import 'dart:math';

import 'package:app/core/models/product.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/swipe/card_align.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../loading.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 0.0),
  Alignment(0.0, 0.0),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class SwipeCardSection extends StatefulWidget {
  int _curIdx = 0;
  SwipeCardSection(BuildContext context) {
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
  List<Product> items;
  List<SwipeCardAlignment> cards = List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;
  double opacityPass = 0.0;
  double opacityLike = 0.0;
  double opacityNope = 0.0;

  @override
  void initState() {
    super.initState();
    // Init cards
    // for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
    //   cards.add(SwipeCardAlignment(cardsCounter));
    // }

    frontCardAlign = cardsAlign[2];
    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SwipeModel>(
      model:
          SwipeModel(Provider.of(context), Provider.of(context, listen: false)),
      onModelReady: (model) {
        model.fetchItems();
      },
      builder: (context, model, child) {
        return model.busy
            ? LoadingWidget()
            : Expanded(
                child: Stack(
                children: <Widget>[
                  backCard(context),
                  middleCard(context),
                  frontCard(context),
                  nopeTextWidget(),
                  passTextWidget(),
                  likeTextWidget(),
                  _controller.status != AnimationStatus.forward
                      ? SizedBox.expand(
                          child: GestureDetector(
                          // While dragging the first card
                          // onHorizontalDragStart: (details) => {},
                          onPanUpdate: (DragUpdateDetails details) {
                            // Add what the user swiped in the last frame to the alignment of the card
                            double pass = 0.0;
                            double like = 0.0;
                            double nope = 0.0;
                            details.globalPosition.dy;
                            if (frontCardAlign.x > 2.5) {
                              //LIKE
                              like = frontCardAlign.x / 6;
                              if (like >= 1) like = 1.0;
                            } else if (frontCardAlign.x < -2.5) {
                              nope = -frontCardAlign.x / 6;
                              if (nope >= 1) nope = 1.0;
                            } else if (frontCardAlign.y < -2) {
                              // PASS
                              pass = -(frontCardAlign.y / 12);
                              if (pass >= 1) pass = 1.0;
                            }
                            setState(() {
                              opacityLike = like;
                              opacityNope = nope;
                              opacityPass = pass;
                              print(details.delta.dx);
                              print(details.delta.dy);
                              frontCardAlign = Alignment(
                                  frontCardAlign.x +
                                      15 *
                                          details.delta.dx /
                                          MediaQuery.of(context).size.width,
                                  frontCardAlign.y +
                                      40 *
                                          details.delta.dy /
                                          MediaQuery.of(context).size.height);
                              frontCardRot =
                                  frontCardAlign.x; // * rotation speed;
                            });
                          },
                          // When releasing the first card
                          onPanEnd: (_) {
                            // If the front card was swiped far enough to count as swiped
                            setState(() {
                              opacityPass = 0.0;
                              opacityLike = 0.0;
                              opacityNope = 0.0;
                            });
                            if (frontCardAlign.x > 3.0) {
                              model.likeRequest();
                              //print(Provider.of<DressRoomService>(context,
                              //                                   listen: false).items[0];
                              //);

                              //Provider.of<List<Product>>(context, listen: false)
                              //    .add(model.items[model.curIdx]);
                              // Provider.of<DressRoomService>(context,
                              //         listen: false)
                              //     .addItem([
                              //   ...Provider.of<List<Product>>(context,
                              //       listen: false),
                              //   model.items[model.curIdx]
                              // ]);
                              print("like");
                              animateCards();
                            } else if (frontCardAlign.x < -3.0) {
                              model.dislikeRequest();
                              print("dislike");
                              animateCards();
                            } else if (frontCardAlign.y < -3.0) {
                              model.passRequest();
                              print("pass");
                              animateCards();
                            } else {
                              // Return to the initial rotation and alignment
                              setState(() {
                                frontCardAlign = defaultFrontCardAlign;
                                frontCardRot = 0.0;
                              });
                            }
                          },
                        ))
                      : Container(),
                ],
              ));
      },
    );
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
              opacity: opacityLike,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Color.fromRGBO(238, 123, 118, 1), width: 5)),
                  child: Text(
                    'LIKE',
                    style: redHeaderStyle,
                  ),
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
              opacity: opacityNope,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Color.fromRGBO(78, 161, 158, 1), width: 5)),
                  child: Text(
                    'NOPE',
                    style: blueHeaderStyle,
                  ),
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
              opacity: opacityPass,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 30),
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white, width: 5)),
                  child: Text(
                    'PASS',
                    style: whiteHeaderStyle,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget backCard(BuildContext context) {
    Product item =
        Provider.of<SwipeModel>(context).items[(widget._curIdx + 2) % 9];
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: SwipeCardAlignment(item)),
    );
  }

  Widget middleCard(BuildContext context) {
    Product item =
        Provider.of<SwipeModel>(context).items[(widget._curIdx + 1) % 9];
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: SwipeCardAlignment(item)),
    );
  }

  Widget frontCard(BuildContext context) {
    //int idx = Provider.of<SwipeModel>(context).curIdx;
    Product item = Provider.of<SwipeModel>(context).items[widget._curIdx % 9];
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(
              size: cardsSize[0], child: SwipeCardAlignment(item)),
        ));
  }

  void changeCardsOrder() {
    //model.nextItem();
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      // var temp = cards[0];
      // cards[0] = cards[1];
      // cards[1] = cards[2];
      // cards[2] = temp;
      // cards[2] = SwipeCardAlignment(cardsCounter);
      widget._curIdx++;
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
