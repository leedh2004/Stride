import 'dart:io';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../mapper.dart';

class DetailInfo extends StatefulWidget {
  SwipeModel model;
  DetailInfo(this.model);
  ScrollController controller;
  List<CachedNetworkImageProvider> images = new List();
  List<CachedNetworkImage> imgs = new List();
  RecentItem item;
  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.item = Provider.of<SwipeService>(context, listen: false)
        .items[(widget.model.index)];

    for (int i = 0; i < widget.item.image_urls.length; i++) {
      widget.images.add(CachedNetworkImageProvider(
        widget.item.image_urls[i],
        headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
      ));
      widget.imgs.add(CachedNetworkImage(
        imageUrl: widget.item.image_urls[i],
        placeholder: (context, url) => CupertinoActivityIndicator(),
        httpHeaders: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
        fit: BoxFit.cover,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    RecentItem item = widget.item;

    String concept = "";
    for (var i = 0; i < item.shop_concept.length; i++) {
      concept += '#';
      concept += item.shop_concept[i];
      if (i != item.shop_concept.length - 1) concept += ', ';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: BaseWidget<SwipeModel>(
                  model: widget.model,
                  builder: (context, model, child) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Stack(children: [
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: Hero(
                                    tag: item.product_id,
                                    // tag: item.image_urls[model.image_index],
                                    child: GestureDetector(
                                      onTapUp: (details) {
                                        double standard =
                                            MediaQuery.of(context).size.width /
                                                2;
                                        if (standard <
                                            details.globalPosition.dx) {
                                          model.nextImage();
                                        } else {
                                          model.prevImage();
                                        }
                                      },
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(32),
                                              bottomRight: Radius.circular(32)),
                                          child:
                                              widget.imgs[model.image_index]),
                                    )),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.75 -
                                        30,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          item.image_urls.length, (idx) {
                                        if (item.image_urls.length == 1)
                                          return Container();
                                        return idx == model.image_index
                                            ? Container(
                                                width: 24,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                margin: EdgeInsets.fromLTRB(
                                                    2, 5, 2, 0),
                                                height: 4,
                                              )
                                            : Container(
                                                width: 24,
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                margin: EdgeInsets.fromLTRB(
                                                    2, 5, 2, 0),
                                                height: 4,
                                              );
                                      })),
                                ),
                              ),
                            ]),
                          ),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFF8569EF)),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 10, 4),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            Stride.logEvent(
                                              name:
                                                  'SWIPE_INFO_PURCHASE_BUTTON_CLICKED',
                                            );
                                            // 이 부분 코드는 나중��� 수정해야할 듯.
                                            Provider.of<SwipeService>(context,
                                                    listen: false)
                                                .purchaseItem(item.product_id);
                                            return ProductWebView(
                                                item.product_url,
                                                item.shop_name);
                                          }));
                                        },
                                        child: Container(
                                          width: 54,
                                          height: 54,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(27),
                                            color: Color(0xFF8569EF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
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
                              padding: EdgeInsets.all(16),
                              child: SizeDialog(item)),
                          UIHelper.verticalSpaceMedium,
                          UIHelper.verticalSpaceMedium,
                          UIHelper.verticalSpaceMedium,
                        ]);
                  })),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white10, Colors.white])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.maybePop(context, "dislike");
                    },
                    // padding: EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/dislike_button.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  // RawMaterialButton(
                  //   constraints: BoxConstraints(minWidth: 60),
                  //   onPressed: () {
                  //     Navigator.maybePop(context, "dislike");
                  //   },
                  //   elevation: 2.0,
                  //   fillColor: Colors.white,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(0),
                  //     child: SvgPicture.asset(
                  //       'images/times.svg',
                  //       width: 25.0,
                  //       color: Color.fromRGBO(72, 116, 213, 1),
                  //     ),
                  //   ),
                  //   padding: EdgeInsets.all(10.0),
                  //   shape: CircleBorder(),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.maybePop(context, "collect");
                    },
                    // padding: EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/star_button.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.maybePop(context, "like");
                    },
                    // padding: EdgeInsets.all(0),
                    child: Image.asset(
                      'assets/heart_button.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  // RawMaterialButton(
                  //   onPressed: () {
                  //     Navigator.maybePop(context, "collect");
                  //   },
                  //   elevation: 2.0,
                  //   fillColor: Colors.white,
                  //   child: FaIcon(
                  //     FontAwesomeIcons.solidStar,
                  //     color: backgroundColor,
                  //     size: 25,
                  //   ),
                  // child: SvgPicture.asset(
                  //   'images/buy.svg',
                  //   width: 25.0,
                  //   color: backgroundColor,
                  // ),
                  // padding: EdgeInsets.all(10.0),
                  // shape: CircleBorder(),
                  // ),
                  // RawMaterialButton(
                  //   constraints: BoxConstraints(minWidth: 60),
                  //   onPressed: () {
                  //     Navigator.maybePop(context, "like");
                  //   },
                  //   elevation: 2.0,
                  //   fillColor: Colors.white,
                  //   child: SvgPicture.asset(
                  //     'images/like.svg',
                  //     width: 25.0,
                  //     color: pinkColor,
                  //   ),
                  //   padding: EdgeInsets.all(10.0),
                  //   shape: CircleBorder(),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 60, 0, 0),
            child: InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF8569EF)),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                      size: 15,
                    ),
                    // child: Image.asset('assets/left-arrow.png',
                    // width: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// class DetailInfo extends StatelessWidget {
//   SwipeModel model;
//   DetailInfo(this.model);
//   ScrollController controller;
//   List<dynamic> images = new List<dynamic>();

// }

const shopNameStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20);
const conceptStyle = TextStyle(
    fontWeight: FontWeight.w700, fontSize: 16, color: backgroundColor);
const titleStyle = TextStyle(fontSize: 20);
const priceStyle = TextStyle(fontSize: 16);
const buyStyle = TextStyle(fontSize: 20, color: Colors.white);
