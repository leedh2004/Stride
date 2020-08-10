import 'dart:io';

import 'package:app/core/models/product.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/product_web_view.dart';
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
    //print("!!!!!!!!!!!!!!!!");
    //print(item.price);
    //print(item.thumbnail_url);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black45, width: 0.5)),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 17,
              child: Image.network(
                item.thumbnail_url,
                fit: BoxFit.cover,
                headers: {
                  HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                },
              ),
            ),
            // child: FancyShimmerImage(
            //   imageUrl: item.thumbnail_url,
            //   boxFit: BoxFit.cover,
            //   errorWidget: Icon(Icons.error),
            //   shimmerBaseColor: backgroundTransparentColor,
            //   shimmerHighlightColor: backgroundColor,
            //   shimmerBackColor: backgroundColor,
            //   // placeholder: (context, url) => LoadingWidget(),
            // )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.product_name,
                              style: subHeaderStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('Price ${item.price}')
                          ],
                        ),
                      ),
                      UIHelper.horizontalSpaceMediumLarge
                    ]),
              ),
            )
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
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  border: Border.all(color: backgroundColor, width: 5)),
            ),
          ),
        ),
        Opacity(
          opacity: 1 - opacity / 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 18,
              icon: FaIcon(FontAwesomeIcons.gift),
              color: backgroundColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductWebView(item.product_url)));
              },
            ),
          ),
        ),
      ]),
    );
  }
}
