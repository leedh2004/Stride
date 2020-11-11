import 'dart:io';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/widgets/swipe/circle_color.dart';
import 'package:app/ui/widgets/swipe/size_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

final Map<String, String> typeConverter = {
  'top': '상의',
  'pants': '하의',
  'dress': '드레스',
  'skirt': '치마',
  'outer': '아우터'
};

class RecentDetailInfo extends StatefulWidget {
  RecentDetailInfo(this.item, this.model, this.show);
  final RecentItem item;
  final RecentItemModel model;
  final bool show;
  List<CachedNetworkImageProvider> images = new List();
  List<CachedNetworkImage> imgs = new List();
  @override
  _RecentDetailInfoState createState() => _RecentDetailInfoState();
}

class _RecentDetailInfoState extends State<RecentDetailInfo> {
  int index = 0;
  bool likes;
  bool haveResult = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    for (int i = 0; i < widget.images.length; i++) {
      precacheImage(widget.images[i], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    likes = widget.item.likes;
    var item = widget.item;
    print(likes);
    if (likes == null) haveResult = false;

    String concept = "";
    for (var i = 0; i < item.shop_concept.length; i++) {
      concept += '#';
      concept += item.shop_concept[i];
      if (i != item.shop_concept.length - 1) concept += ', ';
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (BuildContext context) {
          return SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
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
                                      if (standard <
                                          details.globalPosition.dx) {
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
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(32),
                                            bottomRight: Radius.circular(32)),
                                        child: widget.imgs[index]),
                                  )),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.75 -
                                      30,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        widget.item.image_urls.length, (idx) {
                                      if (widget.item.image_urls.length == 1)
                                        return Container();
                                      return idx == index
                                          ? Container(
                                              width: 24,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              margin: EdgeInsets.fromLTRB(
                                                  2, 5, 2, 0),
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
                                        Stride.logEvent(
                                          name:
                                              'RECOMMEND_PURCHASE_BUTTON_CLICKED',
                                        );
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
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
                                          borderRadius:
                                              BorderRadius.circular(27),
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
                            padding: EdgeInsets.all(16),
                            child: SizeDialog(widget.item)),
                        UIHelper.verticalSpaceMedium,
                        UIHelper.verticalSpaceMedium,
                        UIHelper.verticalSpaceMedium,
                      ])),
              widget.show
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white10, Colors.white])),
                        // height: MediaQuery.of(context).size.height * 0.75,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                !haveResult
                                    ? InkWell(
                                        onTap: () {
                                          Stride.logEvent(
                                              name:
                                                  "RECOMMEND_DISLIKE_BUTTON_CLICKED");
                                          widget.model.dislikeRequest(
                                              widget.item.product_id);
                                          setState(() {
                                            widget.item.likes = false;
                                            haveResult = true;
                                            likes = false;
                                          });
                                        },
                                        // padding: EdgeInsets.all(0),
                                        child: Image.asset(
                                          'assets/dislike_button.png',
                                          width: 80,
                                          height: 80,
                                        ),
                                      )
                                    : likes
                                        ? InkWell(
                                            onTap: () {
                                              Stride.logEvent(
                                                  name:
                                                      "RECOMMEND_DISLIKE_BUTTON_CLICKED");

                                              widget.model
                                                  .revertAndDislikeRequest(
                                                      widget.item.product_id);
                                              setState(() {
                                                widget.item.likes = false;
                                                likes = false;
                                              });
                                            },
                                            // padding: EdgeInsets.all(0),
                                            child: Image.asset(
                                              'assets/dislike_button.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {},
                                            // padding: EdgeInsets.all(0),
                                            child: Image.asset(
                                              'assets/dislike_button_s.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                          ),
                                InkWell(
                                  onTap: () {
                                    Stride.logEvent(
                                        name:
                                            "RECOMMEND_COLLECT_BUTTON_CLICKED");

                                    widget.model
                                        .collectRequest(widget.item.product_id);
                                    Provider.of<DressRoomService>(context,
                                            listen: false)
                                        .addItem(widget.item);
                                    setState(() {
                                      haveResult = true;
                                      widget.item.likes = true;
                                      likes = true;
                                    });
                                    // collection_flush.show(context);
                                    // Scaffold.of(context).showSnackBar(SnackBar(
                                    //   elevation: 6.0,
                                    //   behavior: SnackBarBehavior.floating,
                                    //   duration: Duration(milliseconds: 1500),
                                    //   backgroundColor:
                                    //       Color.fromRGBO(63, 70, 82, 0.9),
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(10))),
                                    //   content: Row(children: [
                                    //     Image.asset('assets/purple_star.png',
                                    //         width: 30),
                                    //     Padding(
                                    //         padding: EdgeInsets.all(8),
                                    //         child:
                                    //             Text('해당 상품이 드레스룸에 추가되었습니다.')),
                                    //   ]),
                                    // ));
                                  },
                                  // padding: EdgeInsets.all(0),
                                  child: Image.asset(
                                    'assets/star_button.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                !haveResult
                                    ? InkWell(
                                        onTap: () {
                                          Stride.logEvent(
                                              name:
                                                  "RECOMMEND_LIKE_BUTTON_CLICKED");

                                          widget.model.likeRequest(
                                              widget.item.product_id);
                                          setState(() {
                                            widget.item.likes = true;
                                            haveResult = true;
                                            likes = true;
                                          });
                                        },
                                        // padding: EdgeInsets.all(0),
                                        child: Image.asset(
                                          'assets/heart_button.png',
                                          width: 80,
                                          height: 80,
                                        ),
                                      )
                                    : !likes
                                        ? InkWell(
                                            onTap: () {
                                              Stride.logEvent(
                                                  name:
                                                      "RECOMMEND_LIKE_BUTTON_CLICKED");

                                              widget.model.revertAndLikeRequest(
                                                  widget.item.product_id);
                                              setState(() {
                                                widget.item.likes = true;
                                                likes = true;
                                              });
                                            },
                                            // padding: EdgeInsets.all(0),
                                            child: Image.asset(
                                              'assets/heart_button.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {},
                                            // padding: EdgeInsets.all(0),
                                            child: Image.asset(
                                              'assets/heart_button_s.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                          ),
                              ],
                            )),
                      ),
                    )
                  : Container(),
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
          );
        }));
  }
}

const shopNameStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20);
const conceptStyle = TextStyle(
    fontWeight: FontWeight.w700, fontSize: 16, color: backgroundColor);
const titleStyle = TextStyle(fontSize: 20);
const priceStyle = TextStyle(fontSize: 16);
const buyStyle = TextStyle(fontSize: 20, color: Colors.white);
