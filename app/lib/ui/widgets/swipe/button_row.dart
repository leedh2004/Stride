import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buttonRow(SwipeModel model, Function onTapDislikeButton,
    Function onTapPurchaseButton, Function onTapLikeButton, var buyButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      RawMaterialButton(
        onPressed: onTapDislikeButton,
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
        onPressed: onTapPurchaseButton,
        elevation: 2.0,
        fillColor: Colors.white,
        key: buyButton,
        child: SvgPicture.asset(
          'images/buy.svg',
          width: 25.0,
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(10.0),
        shape: CircleBorder(),
      ),
      RawMaterialButton(
        onPressed: onTapLikeButton,
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
