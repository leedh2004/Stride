import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

final Map<String, String> typeConverter = {
  'top': '상의',
  'pants': '하의',
  'dress': '드레스',
  'skirt': '치마',
};

class RecentDetailInfo extends StatefulWidget {
  RecentDetailInfo(this.item, this.model);
  RecentItem item;
  RecentItemModel model;
  @override
  _RecentDetailInfoState createState() => _RecentDetailInfoState();
}

class _RecentDetailInfoState extends State<RecentDetailInfo> {
  int index = 0;
  bool likes;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISOPSE!");
  }

  @override
  Widget build(BuildContext context) {
    likes = widget.item.likes;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Hero(
                      tag: widget.item.image_urls[index],
                      child: GestureDetector(
                        onTapUp: (details) {
                          double standard =
                              MediaQuery.of(context).size.width / 2;
                          if (standard < details.globalPosition.dx) {
                            if (index < widget.item.image_urls.length - 1) {
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
                      children:
                          List.generate(widget.item.image_urls.length, (idx) {
                    if (widget.item.image_urls.length == 1) return Container();
                    return idx == index
                        ? Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
                              height: 5,
                            ),
                          )
                        : Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
                              height: 5,
                            ),
                          );
                  })),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75 + 30,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      iconSize: 44,
                      color: backgroundColor,
                      icon: Icon(
                        Icons.cancel,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          likes
                              ? RawMaterialButton(
                                  constraints: BoxConstraints(minWidth: 60),
                                  onPressed: () {
                                    widget.model
                                        .likeRequest(widget.item.product_id);
                                    setState(() {
                                      likes = false;
                                      widget.item.likes = false;
                                    });
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: SvgPicture.asset(
                                      'images/times.svg',
                                      width: 25.0,
                                      color: Color.fromRGBO(72, 116, 213, 1),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  shape: CircleBorder(),
                                )
                              : RawMaterialButton(
                                  constraints: BoxConstraints(minWidth: 60),
                                  onPressed: () {},
                                  elevation: 2.0,
                                  fillColor: Color.fromRGBO(72, 116, 213, 1),
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
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: SvgPicture.asset(
                              'images/buy.svg',
                              width: 25.0,
                              color: backgroundColor,
                            ),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                          likes
                              ? RawMaterialButton(
                                  constraints: BoxConstraints(minWidth: 60),
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
                                  constraints: BoxConstraints(minWidth: 60),
                                  onPressed: () {
                                    widget.model
                                        .dislikeRequest(widget.item.product_id);
                                    setState(() {
                                      likes = true;
                                      widget.item.likes = true;
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
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.shop_name, style: shopNameStyle),
                  UIHelper.verticalSpaceSmall,
                  Text('#데일리 #스트릿', style: conceptStyle),
                  UIHelper.verticalSpaceSmall,
                  Text('종류: ${typeConverter[widget.item.type]}',
                      style: titleStyle),
                  Text(widget.item.product_name, style: titleStyle),
                  UIHelper.verticalSpaceSmall,
                  Text(
                    '${widget.item.price}원',
                    style: priceStyle,
                  ),
                  //Text('사이즈 정보'),
                  UIHelper.verticalSpaceMedium,
                ],
              ),
            ),
            SizeDialog(SwipeCard.fromRecentItemJson(widget.item.toJson())),
            UIHelper.verticalSpaceMedium,
          ])),
    );
  }
}

const shopNameStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
const conceptStyle = TextStyle(
    fontWeight: FontWeight.w700, fontSize: 12, color: backgroundColor);
const titleStyle = TextStyle(fontSize: 16);
const priceStyle = TextStyle(fontSize: 16);
