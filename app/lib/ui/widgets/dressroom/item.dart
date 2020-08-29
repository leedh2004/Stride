import 'dart:io';
import 'package:app/core/models/product.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DressRoomItemWidget extends StatelessWidget {
  final int index;
  final Product item;
  final double opacity;
  DressRoomItemWidget(this.item, this.opacity, this.index);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 18 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: CachedNetworkImage(
                        imageUrl: item.thumbnail_url,
                        fit: BoxFit.cover,
                        httpHeaders: {
                          HttpHeaders.refererHeader:
                              "http://api-stride.com:5000/"
                        }),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Provider.of<DressRoomModel>(context, listen: false)
                  .selectItem(index);
            },
            child: Opacity(
              opacity: opacity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                iconSize: 20,
                icon: FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (opacity == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductWebView(
                                item.product_url, item.shop_mall)));
                  } else {
                    Provider.of<DressRoomModel>(context, listen: false)
                        .selectItem(index);
                  }
                },
              ),
            ),
          ),
        ]),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.product_name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item.price + '원',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Align(
                  alignment: Alignment.centerRight + Alignment(-0.2, 0),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductWebView(
                                  item.product_url, item.shop_mall)))
                    },
                    child: FaIcon(
                      FontAwesomeIcons.store,
                      color: backgroundColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    ]);
  }
}
