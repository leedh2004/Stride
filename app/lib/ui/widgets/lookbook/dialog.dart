import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LookBookDialog extends StatelessWidget {
  final Coordinate item;
  LookBookDialog(this.item);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16),
      //title: Center(child: Text("나만의 룩")),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    imageUrl: item.top.thumbnail_url,
                    fit: BoxFit.fitWidth,
                    httpHeaders: {
                      HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        item.top.product_name,
                        style: subHeaderStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(item.top.price.toString()),
                    ],
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    imageUrl: item.bottom.thumbnail_url,
                    fit: BoxFit.fitWidth,
                    httpHeaders: {
                      HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        item.bottom.product_name,
                        style: subHeaderStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(item.bottom.price.toString()),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
