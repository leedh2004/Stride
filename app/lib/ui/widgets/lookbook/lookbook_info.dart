import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

final Map<String, String> typeConverter = {
  'top': '상의',
  'pants': '하의',
  'dress': '드레스',
  'skirt': '치마',
  'outer': '아우터'
};

class LookBookInfo extends StatefulWidget {
  LookBookInfo(this.item, this.model);
  final Coordinate item;
  final RecentItemModel model;
  @override
  _LookBookInfoState createState() => _LookBookInfoState();
}

class _LookBookInfoState extends State<LookBookInfo> {
  int page = 0;
  int index = 0;
  bool likes;
  bool haveResult = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("??????????");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISOPSE!");
  }

  @override
  Widget build(BuildContext context) {
    RecentItem item;
    page == 0 ? item = widget.item.top : item = widget.item.bottom;
    likes = item.likes;
    if (likes == null) haveResult = false;
    List<dynamic> images = new List<dynamic>();
    for (int i = 0; i < item.image_urls.length; i++) {
      images.add(Image.network(
        item.image_urls[i],
        headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
        fit: BoxFit.cover,
      ));
    }
    String concept = "";
    for (var c in item.shop_concept) {
      concept += '#${c} ';
    }

    Set precached = Provider.of<SwipeService>(context, listen: false).precached;
    if (!precached.contains(item.product_id)) {
      for (int i = 0; i < images.length; i++) {
        precacheImage(images[i].image, context);
      }
      precached.add(item.product_id);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '${item.product_name}',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Stride.logEvent(
                                name: 'LOOKBOOK_CHANGE_TOP_TYPE_BUTTON_CLICKED',
                              );
                              setState(() {
                                page = 0;
                                index = 0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Container(
                                width: 82,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: page == 0
                                        ? Color(0xFF8569EF)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: page == 0
                                            ? Colors.transparent
                                            : Color(0xFF888C93))),
                                child: Center(
                                  child: Text('상의',
                                      style: page == 0
                                          ? TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)
                                          : TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF888C93),
                                              fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              Stride.logEvent(
                                name:
                                    'LOOKBOOK_CHANGE_BOTTOM_TYPE_BUTTON_CLICKED',
                              );
                              setState(() {
                                page = 1;
                                index = 0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Container(
                                width: 82,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: page == 1
                                        ? Color(0xFF8569EF)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: page == 1
                                            ? Colors.transparent
                                            : Color(0xFF888C93))),
                                child: Center(
                                  child: Text('하의',
                                      style: page == 1
                                          ? TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)
                                          : TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF888C93),
                                              fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                    Container(
                      child: Stack(children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Hero(
                              tag: item.product_id,
                              // tag: item.image_urls[model.image_index],
                              child: GestureDetector(
                                onTapUp: (details) {
                                  double standard =
                                      MediaQuery.of(context).size.width / 2;
                                  if (standard < details.globalPosition.dx) {
                                    // model.nextImage();
                                    if (index < item.image_urls.length - 1) {
                                      setState(() {
                                        index++;
                                      });
                                    }
                                  } else {
                                    if (index > 0) {
                                      setState(() {
                                        index--;
                                      });
                                    }
                                    // model.prevImage();
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(32),
                                      bottomRight: Radius.circular(32)),
                                  child: CachedNetworkImage(
                                    imageUrl: item.image_urls[index],
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    // item.image_urls[model.image_index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.75 - 30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(item.image_urls.length,
                                    (idx) {
                                  if (item.image_urls.length == 1)
                                    return Container();
                                  return idx == index
                                      ? Container(
                                          width: 24,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          margin:
                                              EdgeInsets.fromLTRB(2, 5, 2, 0),
                                          height: 4,
                                        )
                                      : Container(
                                          width: 24,
                                          padding: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          margin:
                                              EdgeInsets.fromLTRB(2, 5, 2, 0),
                                          height: 4,
                                        );
                                })),
                          ),
                        ),
                      ]),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text(item.shop_name, style: shopNameStyle),
                    //           UIHelper.horizontalSpaceSmall,
                    //           Text('${concept}', style: conceptStyle),
                    //         ],
                    //       ),
                    //       // Text(item.shop_name, style: shopNameStyle),
                    //       // UIHelper.verticalSpaceSmall,
                    //       // Text('#데일리 #스트릿', style: conceptStyle),
                    //       Text(item.product_name, style: shopNameStyle),

                    //       // UIHelper.verticalSpaceSmall,
                    //       // Text('종류: ${typeConverter[item.type]}',
                    //       //     style: titleStyle),
                    //       UIHelper.verticalSpaceSmall,
                    //       Row(
                    //         children: [
                    //           Text('${typeConverter[item.type]}',
                    //               style: titleStyle),
                    //           UIHelper.horizontalSpaceSmall,
                    //           Text(
                    //             '${item.price}원',
                    //             style: titleStyle,
                    //           ),
                    //         ],
                    //       ),
                    //       UIHelper.verticalSpaceSmall,
                    //       item.clustered_color != null &&
                    //               item.origin_color != null
                    //           ? Wrap(children: [
                    //               ...List.generate(
                    //                 item.clustered_color.length,
                    //                 (index) => Padding(
                    //                   padding: EdgeInsets.only(right: 4),
                    //                   child: CircleColorWidget(
                    //                       item.clustered_color[index]),
                    //                 ),
                    //               ),
                    //               UIHelper.horizontalSpaceSmall,
                    //               ...List.generate(
                    //                   item.origin_color.length,
                    //                   (index) => index ==
                    //                           item.origin_color.length - 1
                    //                       ? Padding(
                    //                           padding:
                    //                               EdgeInsets.only(right: 4),
                    //                           child: Text(
                    //                               '${item.origin_color[index]}'))
                    //                       : Padding(
                    //                           padding:
                    //                               EdgeInsets.only(right: 4),
                    //                           child: Text(
                    //                               '${item.origin_color[index]},')))
                    //             ])
                    //           : Container(),

                    //       //Text('사이즈 정보'),
                    //       UIHelper.verticalSpaceSmall,
                    //       // Text(item.product_name, style: titleStyle),
                    //       // Text(
                    //       //   '${item.price}원',
                    //       //   style: priceStyle,
                    //       // ),
                    //       //Text('사이즈 정보'),
                    //       // UIHelper.verticalSpaceMedium,
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //     padding: EdgeInsets.all(16), child: SizeDialog(item)),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                    //   child: Center(
                    //     child: InkWell(
                    //       onTap: () {
                    //         Stride.logEvent(
                    //           name: 'LOOKBOOK_PURCHASE_BUTTON_CLICKED',
                    //         );
                    //         Navigator.push(context,
                    //             MaterialPageRoute(builder: (context) {
                    //           // 이 부분 코드는 나중에 수정해야할 듯.
                    //           Provider.of<SwipeService>(context, listen: false)
                    //               .purchaseItem(item.product_id);
                    //           return ProductWebView(
                    //               item.product_url, item.shop_name);
                    //         }));
                    //       },
                    //       child: Container(
                    //         width: 300,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //             color: backgroundColor,
                    //             borderRadius: BorderRadius.circular(25)),
                    //         child: Center(child: Text('구매하기', style: buyStyle)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 27,
                          ),
                          Text(item.shop_name,
                              style: TextStyle(
                                  color: Color(0xFF888C93),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(item.product_name,
                              style: TextStyle(
                                  color: Color(0xFF2B3341),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFF8569EF)),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                    child: Text(
                                      '${typeConverter[item.type]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  )),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                concept,
                                style: TextStyle(
                                    color: Color(0xFF616576),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10),
                              )
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: '${item.price}',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2B3341)),
                                  ),
                                  TextSpan(
                                      text: ' 원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Color(0xFF2B3341)))
                                ])),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      Stride.logEvent(
                                        name:
                                            'SWIPE_INFO_PURCHASE_BUTTON_CLICKED',
                                      );
                                      // 이 부분 코드는 나중��� 수정해야할 듯.
                                      Provider.of<SwipeService>(context,
                                              listen: false)
                                          .purchaseItem(item.product_id);
                                      return ProductWebView(
                                          item.product_url, item.shop_name);
                                    }));
                                  },
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27),
                                      color: Color(0xFF8569EF),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Image.asset(
                                        'assets/shopping-bag@2x.png',
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(),
                          SizedBox(
                            height: 16,
                          ),

                          Text('색상정보',
                              style: TextStyle(
                                  color: Color(0xFF888C93),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          SizedBox(
                            height: 14,
                          ),
                          item.clustered_color != null &&
                                  item.origin_color != null
                              ? Wrap(children: [
                                  ...List.generate(
                                    item.clustered_color.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: CircleColorWidget(
                                          item.clustered_color[index]),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  // ...List.generate(
                                  //     item.origin_color.length,
                                  //     (index) => index ==
                                  //             item.origin_color.length - 1
                                  //         ? Padding(
                                  //             padding: EdgeInsets.only(
                                  //                 right: 4),
                                  //             child: Text(
                                  //                 '${item.origin_color[index]}'))
                                  //         : Padding(
                                  //             padding: EdgeInsets.only(
                                  //                 right: 4),
                                  //             child: Text(
                                  //                 '${item.origin_color[index]},')))
                                ])
                              : Container(),

                          //Text('사이즈 정보'),
                          UIHelper.verticalSpaceSmall,
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(16), child: SizeDialog(item)),
                    UIHelper.verticalSpaceMedium,
                  ])),
        ),
      ),
    );
  }
}

const shopNameStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20);
const conceptStyle = TextStyle(
    fontWeight: FontWeight.w700, fontSize: 16, color: backgroundColor);
const titleStyle = TextStyle(fontSize: 20);
const priceStyle = TextStyle(fontSize: 16);
