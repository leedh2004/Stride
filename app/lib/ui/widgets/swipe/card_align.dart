import 'dart:io';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/swipe/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../mapper.dart';

class SwipeCardAlignment extends StatefulWidget {
  RecentItem item;
  int index;
  List<dynamic> images = new List<dynamic>();
  String concepts = "";

  SwipeCardAlignment(RecentItem _item, int _index) {
    item = _item;
    for (var i = 0; i < item.shop_concept.length; i++) {
      concepts += '#';
      concepts += item.shop_concept[i];
      if (i != item.shop_concept.length - 1) concepts += ', ';
    }
    index = _index;
    if (index >= item.length) {
      index = item.length - 1;
    }
    for (int i = 0; i < item.image_urls.length; i++) {
      images.add(Image.network(
        item.image_urls[i],
        headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
        fit: BoxFit.cover,
      ));
    }
  }

  @override
  _SwipeCardAlignmentState createState() => _SwipeCardAlignmentState();
} //StatefulWidget은 폐기 됨

class _SwipeCardAlignmentState extends State<SwipeCardAlignment> {
  //State는 폐기되지 않아
  @override
  void initState() {
    print("INIT");
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("UPDATE");
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SwipeCardAlignment oldWidget) {
    // TODO: implement didUpdateWidget
    // print("WTF!");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // print("BUILD");
    Set precached = Provider.of<SwipeService>(context, listen: false).precached;
    if (!precached.contains(widget.item.product_id)) {
      for (int i = 0; i < widget.images.length; i++) {
        precacheImage(widget.images[i].image, context);
      }
      precached.add(widget.item.product_id);
    }

    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              SizedBox.expand(
                  child: AspectRatio(
                      aspectRatio: 11 / 16,
                      child: Hero(
                        tag: widget.item.product_id,
                        // tag: widget.item.image_urls[widget.index],
                        child: widget.images[widget.index],
                      ))),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.item.length, (idx) {
                        if (widget.item.length == 1) return Container();
                        return idx == widget.index
                            ? Container(
                                width: 24,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4)),
                                margin: EdgeInsets.fromLTRB(2, 5, 2, 0),
                                height: 4,
                              )
                            : Container(
                                width: 24,
                                padding: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                    borderRadius: BorderRadius.circular(4)),
                                margin: EdgeInsets.fromLTRB(2, 5, 2, 0),
                                height: 4,
                              );
                      })),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black12,
                    Colors.black26,
                    Colors.black54
                  ], stops: [
                    0.1,
                    0.2,
                    0.4,
                    0.9
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              // "심플 스트라이프 셔츠",
                              widget.item.product_name, //'로드리 스커트',
                              style: whiteShadowStyle,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.info,
                                  size: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '${widget.item.price}',
                            style: whiteSmallShadowStyle,
                          ),
                          TextSpan(
                              text: ' 원',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white))
                        ])),
                        SizedBox(
                          height: 8,
                        ),

                        Row(children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF8569EF)),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                child: Text(
                                  '${typeConverter[widget.item.type]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              )),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.concepts,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                fontWeight: FontWeight.w700,
                                fontSize: 10),
                          )
                        ]),
                        // style: TextStyle(
                        //     fontSize: 40, fontFamily: 'NotoSansKR'))
                      ]),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
              //     child: IconButton(
              //       icon: Container(
              //         width: 50,
              //         height: 50,
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(25)),
              //         child: Center(
              //           child: FaIcon(
              //             FontAwesomeIcons.info,
              //             size: 15,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       onPressed: () {},
              //     ),
              //   ),
              // ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Image.asset(
                      'assets/shopping-bag@2x.png',
                      width: 30,
                    ),
                  )
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 0, 70, 20),
                  //   child: IconButton(
                  //     icon: Container(
                  //       width: 50,
                  //       height: 50,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(25)),
                  //       child: Center(

                  //         child: FaIcon(
                  //           FontAwesomeIcons.shoppingCart,
                  //           size: 15,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       print("wtf");
                  //     },
                  //   ),
                  // ),
                  ),
            ],
          )),
    );
  }
}
