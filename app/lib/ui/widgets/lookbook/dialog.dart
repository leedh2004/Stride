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
    return Scaffold(
        //title: Center(child: Text("나만의 룩")),
        backgroundColor: Colors.transparent,
        body: SizedBox.expand(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  enableFeedback: false,
                  canRequestFocus: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                )),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 11 / 16,
                          child: CachedNetworkImage(
                            imageUrl: item.top.thumbnail_url,
                            fit: BoxFit.fitHeight,
                            httpHeaders: {
                              HttpHeaders.refererHeader:
                                  "http://api-stride.com:5000/"
                            },
                          ),
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
                ),
                Container(
                  color: Colors.white,
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 11 / 16,
                          child: CachedNetworkImage(
                            imageUrl: item.bottom.thumbnail_url,
                            fit: BoxFit.fitHeight,
                            httpHeaders: {
                              HttpHeaders.refererHeader:
                                  "http://api-stride.com:5000/"
                            },
                          ),
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
                  ),
                ),
                Expanded(
                    child: InkWell(
                  enableFeedback: false,
                  canRequestFocus: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}
