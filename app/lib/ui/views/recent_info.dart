import 'dart:io';

import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

final Map<String, String> typeConverter = {
  'top': '상의',
  'pants': '하의',
  'dress': '드레스',
  'skirt': '치마',
  'outer': '아우터'
};

class RecentDetailInfo extends StatefulWidget {
  RecentDetailInfo(this.item, this.model);
  final RecentItem item;
  final RecentItemModel model;
  @override
  _RecentDetailInfoState createState() => _RecentDetailInfoState();
}

class _RecentDetailInfoState extends State<RecentDetailInfo> {
  int index = 0;
  bool likes;
  bool haveResult = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISOPSE!");
  }

  @override
  Widget build(BuildContext context) {
    likes = widget.item.likes;
    print(likes);
    if (likes == null) haveResult = false;
    List<dynamic> images = new List<dynamic>();
    for (int i = 0; i < widget.item.image_urls.length; i++) {
      images.add(Image.network(
        widget.item.image_urls[i],
        headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
        fit: BoxFit.cover,
      ));
    }

    Set precached = Provider.of<SwipeService>(context, listen: false).precached;
    if (!precached.contains(widget.item.product_id)) {
      for (int i = 0; i < images.length; i++) {
        precacheImage(images[i].image, context);
      }
      precached.add(widget.item.product_id);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Hero(
                              tag: widget.item.product_id,
                              // tag: widget.item.image_urls[index],
                              child: GestureDetector(
                                onTapUp: (details) {
                                  double standard =
                                      MediaQuery.of(context).size.width / 2;
                                  if (standard < details.globalPosition.dx) {
                                    if (index <
                                        widget.item.image_urls.length - 1) {
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
                                  }
                                },
                                child: Image.network(
                                  widget.item.image_urls[index],
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                              children: List.generate(
                                  widget.item.image_urls.length, (idx) {
                            if (widget.item.image_urls.length == 1)
                              return Container();
                            return idx == index
                                ? Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
                                      height: 5,
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
                                      height: 5,
                                    ),
                                  );
                          })),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.75 + 25,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      padding: EdgeInsets.all(0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                gradientStart,
                                                backgroundColor
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        child: Container(
                                            width: 50,
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: FaIcon(
                                              FontAwesomeIcons.arrowDown,
                                              color: Colors.white,
                                            )),
                                      )),
                                ),
                              )),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  !haveResult || likes
                                      ? RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {
                                            widget.model.dislikeRequest(
                                                widget.item.product_id);
                                            setState(() {
                                              widget.item.likes = false;
                                              haveResult = true;
                                              likes = false;
                                            });
                                          },
                                          elevation: 2.0,
                                          fillColor: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: SvgPicture.asset(
                                              'images/times.svg',
                                              width: 25.0,
                                              color: Color.fromRGBO(
                                                  72, 116, 213, 1),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          shape: CircleBorder(),
                                        )
                                      : RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {},
                                          elevation: 2.0,
                                          fillColor:
                                              Color.fromRGBO(72, 116, 213, 1),
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: SvgPicture.asset(
                                              'images/times.svg',
                                              width: 25.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          shape: CircleBorder(),
                                        ),
                                  RawMaterialButton(
                                    constraints: BoxConstraints(minWidth: 60),
                                    onPressed: () {
                                      Navigator.pop(context, "collect");
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: FaIcon(
                                      FontAwesomeIcons.thLarge,
                                      color: backgroundColor,
                                      size: 25,
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    shape: CircleBorder(),
                                  ),
                                  haveResult && likes
                                      ? RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {},
                                          elevation: 2.0,
                                          fillColor: pinkColor,
                                          child: SvgPicture.asset(
                                            'images/like.svg',
                                            width: 25.0,
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          shape: CircleBorder(),
                                        )
                                      : RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {
                                            widget.model.likeRequest(
                                                widget.item.product_id);
                                            setState(() {
                                              widget.item.likes = true;
                                              haveResult = true;
                                              likes = true;
                                            });
                                          },
                                          elevation: 2.0,
                                          fillColor: Colors.white,
                                          child: SvgPicture.asset(
                                            'images/like.svg',
                                            width: 25.0,
                                            color: pinkColor,
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          shape: CircleBorder(),
                                        ),
                                ],
                              )),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(widget.item.shop_name, style: shopNameStyle),
                              UIHelper.horizontalSpaceSmall,
                              Text('#데일리 #스트릿', style: conceptStyle),
                            ],
                          ),
                          // Text(widget.item.shop_name, style: shopNameStyle),
                          // UIHelper.verticalSpaceSmall,
                          // Text('#데일리 #스트릿', style: conceptStyle),
                          Text(widget.item.product_name, style: shopNameStyle),

                          // UIHelper.verticalSpaceSmall,
                          // Text('종류: ${typeConverter[widget.item.type]}',
                          //     style: titleStyle),
                          UIHelper.verticalSpaceSmall,
                          Row(
                            children: [
                              Text('${typeConverter[widget.item.type]}',
                                  style: titleStyle),
                              UIHelper.horizontalSpaceSmall,
                              Text(
                                '${widget.item.price}원',
                                style: titleStyle,
                              ),
                            ],
                          ),
                          UIHelper.verticalSpaceSmall,
                          widget.item.clustered_color != null &&
                                  widget.item.origin_color != null
                              ? Wrap(children: [
                                  ...List.generate(
                                    widget.item.clustered_color.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: CircleColorWidget(
                                          widget.item.clustered_color[index]),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  ...List.generate(
                                      widget.item.origin_color.length,
                                      (index) => index ==
                                              widget.item.origin_color.length -
                                                  1
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                  '${widget.item.origin_color[index]}'))
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                  '${widget.item.origin_color[index]},')))
                                ])
                              : Container(),

                          //Text('사이즈 정보'),
                          UIHelper.verticalSpaceSmall,
                          // Text(widget.item.product_name, style: titleStyle),
                          // Text(
                          //   '${widget.item.price}원',
                          //   style: priceStyle,
                          // ),
                          //Text('사이즈 정보'),
                          // UIHelper.verticalSpaceMedium,
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: SizeDialog(widget.item)),
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
