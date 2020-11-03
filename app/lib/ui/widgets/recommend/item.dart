import 'dart:io';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RecommendItemWidget extends StatelessWidget {
  final RecentItem item;
  final RecentItemModel model;
  RecommendItemWidget(this.item, this.model);

  @override
  Widget build(BuildContext context) {
    String concept = "";
    for (var c in item.shop_concept) {
      concept += '#${c} ';
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 12, 0),
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
            return RecentDetailInfo(item, model, true);
          }));

          if (await result == 'collect') {
            // ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
            //   duration: Duration(milliseconds: 1500),
            //   content: Text('해당상품이 드레스룸에 추가되었습니다.'),
            // ));
            collection_flush.show(context);
          }
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 180,
            height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: item.product_id,
                child: Image.network(
                  item.image_urls[0],
                  fit: BoxFit.cover,
                  // httpHeaders: {
                  //   HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                  // }
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 180,
            child: Text(
              item.product_name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(item.price + '원',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 172,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(244, 244, 251, 1)),
                        child: Text('${typeConverter[item.type]}')),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '$concept',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                InkWell(
                    onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            Stride.analytics.logEvent(
                                name: 'RECOMMEND_PURCHASE_BUTTON_CLICKED',
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
                      child: Image.asset(
                        'assets/buy.png',
                        width: 30,
                      ),
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
