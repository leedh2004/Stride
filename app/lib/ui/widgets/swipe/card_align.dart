import 'dart:io';

import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SwipeCardAlignment extends StatelessWidget {
  //final int cardNum;

  final SwipeCard item;
  SwipeCardAlignment(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              SizedBox.expand(
                child: AspectRatio(
                  aspectRatio: 11 / 16,
                  child: CachedNetworkImage(
                      imageUrl: item.thumbnail_url,
                      httpHeaders: {
                        HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                      },
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black12,
                    Colors.black26,
                    Colors.black54
                  ], stops: [
                    0.1,
                    0.2,
                    0.4,
                    0.9
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.product_name, //'로드리 스커트',
                          style: whiteShadowStyle,
                        ),
                        Text(
                          item.price + '원',
                          style: whiteSmallShadowStyle,
                        )
                      ]),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: FaIcon(
                    FontAwesomeIcons.rulerVertical,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
