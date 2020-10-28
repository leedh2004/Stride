import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/main.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DressRoomItemWidget extends StatelessWidget {
  final int index;
  final RecentItem item;
  final double opacity;
  final RecentItemModel model;
  DressRoomItemWidget(this.item, this.opacity, this.index, this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(children: [
              Positioned.fill(
                child: Hero(
                  tag: item.product_id,
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnail_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Provider.of<DressRoomModel>(context, listen: false)
                      .selectItem(index);
                },
                child: Opacity(
                  opacity: opacity / 2,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
              opacity > 0
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          Stride.analytics.logEvent(
                              name: 'DRESSROOM_ITEM_INFO_CLICKED',
                              parameters: {
                                'itemId': item.product_id.toString(),
                                'itemName': item.product_name,
                                'itemCategory': item.shop_name
                              });
                          Navigator.push(context, MaterialPageRoute<String>(
                              builder: (BuildContext context) {
                            return RecentDetailInfo(item, model, false);
                          }));
                        },
                        child: Image.asset(
                          'assets/search.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    )
                  : Container()
            ]),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text('${item.product_name}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(
          height: 8,
        ),
        Text('${item.price}원',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(
          height: 8,
        ),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromRGBO(244, 244, 251, 1)),
                  child: Text(
                    '${typeConverter[item.type]}',
                    style: TextStyle(fontSize: 10),
                  )),
              InkWell(
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
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/buy.png',
                      width: 30,
                    ),
                  ))
            ]),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(children: [
  //     Expanded(
  //       child: Stack(children: <Widget>[
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Expanded(
  //               child: AspectRatio(
  //                 aspectRatio: 18 / 1,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(3),
  //                   child: Hero(
  //                     tag: item.product_id,
  //                     child: CachedNetworkImage(
  //                         imageUrl: item.compressed_thumbnail_url,
  //                         fit: BoxFit.cover,
  //                         httpHeaders: {
  //                           HttpHeaders.refererHeader:
  //                               "http://api-stride.com:5000/"
  //                         }),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Provider.of<DressRoomModel>(context, listen: false)
  //                 .selectItem(index);
  //           },
  //           child: Opacity(
  //             opacity: opacity,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(3)),
  //                 color: Color.fromRGBO(0, 0, 0, 0.4),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Opacity(
  //           opacity: opacity,
  //           child: Align(
  //             alignment: Alignment.bottomRight,
  //             child: IconButton(
  //               iconSize: 20,
  //               icon: FaIcon(
  //                 FontAwesomeIcons.search,
  //                 color: Colors.white,
  //               ),
  //               onPressed: () async {
  //                 if (opacity == 1) {
  //                   Stride.analytics.logEvent(
  //                       name: 'DRESSROOM_ITEM_INFO_CLICKED',
  //                       parameters: {
  //                         'itemId': item.product_id.toString(),
  //                         'itemName': item.product_name,
  //                         'itemCategory': item.shop_name
  //                       });
  //                   final result = Navigator.push(context,
  //                       MaterialPageRoute<String>(
  //                           builder: (BuildContext context) {
  //                     return RecentDetailInfo(item, model, false);
  //                   }));

  //                   if (await result == 'collect') {
  //                     //                           RecentItem item =
  //                     //     Provider.of<SwipeService>(context, listen: false).items[model.index];
  //                     // model.addItem(item);
  //                     ServiceView.scaffoldKey.currentState
  //                         .showSnackBar(SnackBar(
  //                       duration: Duration(milliseconds: 1500),
  //                       content: Text('해당상품이 콜렉션에 추가되었습니다.'),
  //                     ));
  //                   }
  //                   // Navigator.of(context).push(PageRouteBuilder(
  //                   //     opaque: false,
  //                   //     pageBuilder: (___, _, __) => ProductDialog(item)));
  //                 } else {
  //                   Provider.of<DressRoomModel>(context, listen: false)
  //                       .selectItem(index);
  //                 }
  //               },
  //             ),
  //           ),
  //         ),
  //       ]),
  //     ),
  //     Container(
  //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             item.product_name,
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           Stack(
  //             children: [
  //               Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(item.price + '원',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //               ),
  //               Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: InkWell(
  //                   onTap: () => {
  //                     Navigator.push(context,
  //                         MaterialPageRoute(builder: (context) {
  //                       Stride.analytics.logEvent(
  //                           name: 'DRESSROOM_PURCHASE_BUTTON_CLICKED',
  //                           parameters: {
  //                             'itemId': item.product_id.toString(),
  //                             'itemName': item.product_name,
  //                             'itemCategory': item.shop_name
  //                           });
  //                       // 이 부분 코드는 나중에 수정해야할 듯.
  //                       Provider.of<SwipeService>(context, listen: false)
  //                           .purchaseItem(item.product_id);
  //                       return ProductWebView(item.product_url, item.shop_name);
  //                     }))
  //                   },
  //                   child: SvgPicture.asset(
  //                     'images/buy.svg',
  //                     color: backgroundColor,
  //                     width: 16,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     )
  //   ]);
  // }
}
