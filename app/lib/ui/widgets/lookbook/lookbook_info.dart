import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/collection/view.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
                              setState(() {
                                page = 0;
                                index = 0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('상의',
                                  style: page == 0
                                      ? currentStyle
                                      : notCurrentStyle),
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
                              setState(() {
                                page = 1;
                                index = 0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('하의',
                                  style: page == 1
                                      ? currentStyle
                                      : notCurrentStyle),
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
                              // tag: item.image_urls[index],
                              child: GestureDetector(
                                onTapUp: (details) {
                                  double standard =
                                      MediaQuery.of(context).size.width / 2;
                                  if (standard < details.globalPosition.dx) {
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
                                  }
                                },
                                child: Image.network(
                                  item.image_urls[index],
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                              children:
                                  List.generate(item.image_urls.length, (idx) {
                            if (item.image_urls.length == 1) return Container();
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
                                        Navigator.maybePop(context);
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
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(item.shop_name, style: shopNameStyle),
                              UIHelper.horizontalSpaceSmall,
                              Text('${concept}', style: conceptStyle),
                            ],
                          ),
                          // Text(item.shop_name, style: shopNameStyle),
                          // UIHelper.verticalSpaceSmall,
                          // Text('#데일리 #스트릿', style: conceptStyle),
                          Text(item.product_name, style: shopNameStyle),

                          // UIHelper.verticalSpaceSmall,
                          // Text('종류: ${typeConverter[item.type]}',
                          //     style: titleStyle),
                          UIHelper.verticalSpaceSmall,
                          Row(
                            children: [
                              Text('${typeConverter[item.type]}',
                                  style: titleStyle),
                              UIHelper.horizontalSpaceSmall,
                              Text(
                                '${item.price}원',
                                style: titleStyle,
                              ),
                            ],
                          ),
                          UIHelper.verticalSpaceSmall,
                          item.clustered_color != null &&
                                  item.origin_color != null
                              ? Wrap(children: [
                                  ...List.generate(
                                    item.clustered_color.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: CircleColorWidget(
                                          item.clustered_color[index]),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  ...List.generate(
                                      item.origin_color.length,
                                      (index) => index ==
                                              item.origin_color.length - 1
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                  '${item.origin_color[index]}'))
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4),
                                              child: Text(
                                                  '${item.origin_color[index]},')))
                                ])
                              : Container(),

                          //Text('사이즈 정보'),
                          UIHelper.verticalSpaceSmall,
                          // Text(item.product_name, style: titleStyle),
                          // Text(
                          //   '${item.price}원',
                          //   style: priceStyle,
                          // ),
                          //Text('사이즈 정보'),
                          // UIHelper.verticalSpaceMedium,
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
