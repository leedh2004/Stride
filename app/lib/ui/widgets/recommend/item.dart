import 'dart:io';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/widgets/dressroom/product_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecommendItemWidget extends StatelessWidget {
  final RecentItem item;
  final RecentItemModel model;
  RecommendItemWidget(this.item, this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
      child: InkWell(
        onTap: () async {
          Stride.analytics
              .logEvent(name: 'DRESSROOM_ITEM_INFO_CLICKED', parameters: {
            'itemId': item.product_id.toString(),
            'itemName': item.product_name,
            'itemCategory': item.shop_name
          });
          final result = Navigator.push(context,
              MaterialPageRoute<String>(builder: (BuildContext context) {
            return RecentDetailInfo(item, model);
          }));

          if (await result == 'collect') {
            //                           RecentItem item =
            //     Provider.of<SwipeService>(context, listen: false).items[model.index];
            // model.addItem(item);
            ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Text('해당상품이 콜렉션에 추가되었습니다.'),
            ));
          }
          // Navigator.of(context).push(PageRouteBuilder(
          //     opaque: false, pageBuilder: (___, _, __) => ProductDialog(item)));
        },
        child: Column(children: [
          Expanded(
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 12 / 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Hero(
                          tag: item.product_id,
                          child: CachedNetworkImage(
                              imageUrl: item.compressed_thumbnail_url,
                              fit: BoxFit.cover,
                              httpHeaders: {
                                HttpHeaders.refererHeader:
                                    "http://api-stride.com:5000/"
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            Stride.analytics.logEvent(
                                name: 'DRESSROOM_PURCHASE_BUTTON_CLICKED',
                                parameters: {
                                  'itemId': item.product_id.toString(),
                                  'itemName': item.product_name,
                                  'itemCategory': item.shop_name
                                });
                            // 이 부분 코드는 나중에 수정해야할 듯.
                            Provider.of<SwipeService>(context, listen: false)
                                .purchaseItem(item.product_id);
                            return ProductWebView(
                                item.product_url, item.shop_name);
                          }))
                        },
                        child: SvgPicture.asset(
                          'images/buy.svg',
                          color: backgroundColor,
                          width: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
