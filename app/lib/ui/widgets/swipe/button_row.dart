import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buttonRow(SwipeModel model, Function onTapDislikeButton,
    Function onTapPurchaseButton, Function onTapLikeButton, var buyButton) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      InkWell(
        onTap: onTapDislikeButton,
        // padding: EdgeInsets.all(0),
        child: Image.asset(
          'assets/dislike_button.png',
          width: 80,
          height: 80,
        ),
      ),
      InkWell(
        onTap: onTapPurchaseButton,
        // padding: EdgeInsets.all(0),
        child: Image.asset(
          'assets/star_button.png',
          key: buyButton,
          width: 80,
          height: 80,
        ),
      ),
      InkWell(
        onTap: onTapLikeButton,
        // padding: EdgeInsets.all(0),
        child: Image.asset(
          'assets/heart_button.png',
          width: 80,
          height: 80,
        ),
      ),
    ],
  );
}

// RawMaterialButton(
//   onPressed: onTapLikeButton,
//   elevation: 2.0,
//   fillColor: Colors.white,
//   child: SvgPicture.asset(
//     'images/like.svg',
//     width: 30.0,
//     color: pinkColor,
//   ),
//   padding: EdgeInsets.all(10.0),
//   shape: CircleBorder(),
// ),
