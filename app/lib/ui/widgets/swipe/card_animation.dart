import 'package:app/core/constants/app_constants.dart';
import 'package:app/ui/widgets/swipe/card_gesture.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x >= STANDARD_RIGHT || beginAlign.x <= STANDARD_LEFT) {
      return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
          CurvedAnimation(
              parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
    }
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x >= STANDARD_RIGHT || beginAlign.x <= STANDARD_LEFT) {
      return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
          CurvedAnimation(
              parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
    }
    return SizeTween(begin: cardsSize[2], end: cardsSize[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x >= STANDARD_RIGHT || beginAlign.x <= STANDARD_LEFT) {
      return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
          CurvedAnimation(
              parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
    }
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x >= STANDARD_RIGHT || beginAlign.x <= STANDARD_LEFT) {
      return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
          CurvedAnimation(
              parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
    }
    return SizeTween(begin: cardsSize[1], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    if (beginAlign.x < STANDARD_RIGHT && beginAlign.x > STANDARD_LEFT) {
      return AlignmentTween(
              begin: beginAlign, end: align // Has swiped to the left or right?
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
