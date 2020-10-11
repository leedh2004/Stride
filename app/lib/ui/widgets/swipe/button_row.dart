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
      // Container(
      //   height: 50.0,
      //   child: RaisedButton(
      //     onPressed: () {},
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      //     padding: EdgeInsets.all(0.0),
      //     child: Ink(
      //       decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [
      //               gradientStart,
      //               // gradientStart,
      //               // backgroundColor,
      //               backgroundColor

      //               //Color(0xff374ABE),
      //               //Color(0xff64B6FF)
      //             ],
      //             begin: Alignment.topCenter,
      //             end: Alignment.bottomCenter,
      //           ),
      //           borderRadius: BorderRadius.circular(25.0)),
      //       child: Container(
      //         constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
      //         alignment: Alignment.center,
      //         child: Text(
      //           "콜렉션에 저장",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(fontSize: 16, color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      RawMaterialButton(
        onPressed: onTapPurchaseButton,
        elevation: 2.0,
        fillColor: Colors.white,
        key: buyButton,
        child: FaIcon(
          FontAwesomeIcons.thLarge,
          color: backgroundColor,
          size: 25,
        ),
        // child: SvgPicture.asset(
        //   'images/buy.svg',
        //   width: 25.0,
        //   color: backgroundColor,
        // ),
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
