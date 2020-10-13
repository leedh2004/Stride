import 'dart:io';

import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

final Map<String, String> typeConverter = {
  'top': '상의',
  'pants': '팬츠',
  'dress': '드레스',
  'skirt': '스커트',
  'outer': '아우터'
};

class DetailInfo extends StatelessWidget {
  SwipeModel model;
  DetailInfo(this.model);
  ScrollController controller;
  List<dynamic> images = new List<dynamic>();

  @override
  Widget build(BuildContext context) {
    RecentItem item =
        Provider.of<SwipeService>(context, listen: false).items[(model.index)];
    print("!!!Sx");
    print(item.type);

    for (int i = 0; i < item.image_urls.length; i++) {
      images.add(Image.network(
        item.image_urls[i],
        headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
        fit: BoxFit.cover,
      ));
    }

    Set precached = Provider.of<SwipeService>(context, listen: false).precached;
    if (!precached.contains(item.product_id)) {
      for (int i = 0; i < images.length; i++) {
        precacheImage(images[i].image, context);
      }
      precached.add(item.product_id);
    }
    String concept = "";
    for (var c in item.shop_concept) {
      concept += '#${c} ';
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: BaseWidget<SwipeModel>(
                  model: model,
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
                                      child: Image.network(
                                        item.image_urls[model.image_index],
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                    children: List.generate(
                                        item.image_urls.length, (idx) {
                                  if (item.image_urls.length == 1)
                                    return Container();
                                  return idx == model.image_index
                                      ? Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin:
                                                EdgeInsets.fromLTRB(3, 5, 3, 0),
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
                                            margin:
                                                EdgeInsets.fromLTRB(3, 5, 3, 0),
                                            height: 5,
                                          ),
                                        );
                                })),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.75 +
                                        25,
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
                                                    BorderRadius.circular(
                                                        25.0)),
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
                                                      BorderRadius.circular(
                                                          25.0)),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {
                                            Navigator.maybePop(
                                                context, "dislike");
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
                                        ),
                                        RawMaterialButton(
                                          onPressed: () {
                                            Navigator.maybePop(
                                                context, "collect");
                                          },
                                          elevation: 2.0,
                                          fillColor: Colors.white,
                                          child: FaIcon(
                                            FontAwesomeIcons.thLarge,
                                            color: backgroundColor,
                                            size: 25,
                                          ),
                                          // child: SvgPicture.asset(
                                          //   'images/buy.svg',
                                          //   width: 25.0,
                                          //   color: backgroundColor,
                                          // ),
                                          padding: EdgeInsets.all(10.0),
                                          shape: CircleBorder(),
                                        ),
                                        RawMaterialButton(
                                          constraints:
                                              BoxConstraints(minWidth: 60),
                                          onPressed: () {
                                            Navigator.maybePop(context, "like");
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
                                    Text(item.shop_name, style: shopNameStyle),
                                    UIHelper.horizontalSpaceSmall,
                                    Text('$concept', style: conceptStyle),
                                  ],
                                ),
                                Text(item.product_name, style: shopNameStyle),
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
                                                    padding: EdgeInsets.only(
                                                        right: 4),
                                                    child: Text(
                                                        '${item.origin_color[index]}'))
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 4),
                                                    child: Text(
                                                        '${item.origin_color[index]},')))
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    Stride.analytics.logEvent(
                                        name:
                                            'DRESSROOM_PURCHASE_BUTTON_CLICKED',
                                        parameters: {
                                          'itemId': item.product_id.toString(),
                                          'itemName': item.product_name,
                                          'itemCategory': item.shop_name
                                        });
                                    // 이 부분 코드는 나중에 수정해야할 듯.
                                    Provider.of<SwipeService>(context,
                                            listen: false)
                                        .purchaseItem(item.product_id);
                                    return ProductWebView(
                                        item.product_url, item.shop_name);
                                  }));
                                },
                                child: Container(
                                  width: 300,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                      child: Text('구매하기', style: buyStyle)),
                                ),
                              ),
                            ),
                          )
                        ]);
                  })),
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
const buyStyle = TextStyle(fontSize: 20, color: Colors.white);
