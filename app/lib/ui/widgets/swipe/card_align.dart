import 'dart:io';

import 'package:app/core/models/swipeCard.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class SwipeCardAlignment extends StatelessWidget {
//   SwipeCard item;
//   int index;
//   List<dynamic> images = new List<dynamic>();

//   SwipeCardAlignment(SwipeCard _item, int _index) {
//     item = _item;
//     index = _index;
//     if (index >= item.length) {
//       index = item.length - 1;
//     }

//     for (int i = 0; i < item.length; i++) {
//       images.add(Image.network(
//         item.image_urls[i],
//         headers: {HttpHeaders.refererHeader: "http://api-stride.com:5000/"},
//         fit: BoxFit.cover,
//       ));
//     }
//     print(images.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("BUILD");
//     for (int i = 0; i < images.length; i++) {
//       precacheImage(images[i].image, context);
//     }
//     return Container(
//       padding: EdgeInsets.only(top: 30),
//       child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           elevation: 3,
//           clipBehavior: Clip.antiAlias,
//           child: Stack(
//             alignment: Alignment.bottomLeft,
//             children: <Widget>[
//               SizedBox.expand(
//                 child: AspectRatio(
//                   aspectRatio: 11 / 16,
//                   child: images[index],
//                   // child: CachedNetworkImage(
//                   //     imageUrl: item.image_urls[index],
//                   //     httpHeaders: {
//                   //       HttpHeaders.refererHeader: "http://api-stride.com:5000/"
//                   //     },
//                   //     fit: BoxFit.cover),
//                 ),
//               ),
//               //   child: CachedNetworkImage(
//               //       imageUrl: widget.item.image_urls[widget.index],
//               //       httpHeaders: {
//               //         HttpHeaders.refererHeader: "http://api-stride.com:5000/"
//               //       },
//               //       fit: BoxFit.cover),
//               // ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Row(
//                     children: List.generate(item.length, (idx) {
//                   if (item.length == 1) return Container();
//                   return idx == index
//                       ? Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10)),
//                             margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
//                             height: 5,
//                           ),
//                         )
//                       : Expanded(
//                           child: Container(
//                             padding: EdgeInsets.only(top: 10),
//                             decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius: BorderRadius.circular(10)),
//                             margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
//                             height: 5,
//                           ),
//                         );
//                 })),
//               ),
//               Container(
//                 alignment: Alignment.bottomLeft,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     Colors.transparent,
//                     Colors.black12,
//                     Colors.black26,
//                     Colors.black54
//                   ], stops: [
//                     0.1,
//                     0.2,
//                     0.4,
//                     0.9
//                   ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           item.product_name, //'로드리 스커트',
//                           style: whiteShadowStyle,
//                         ),
//                         Text(
//                           item.price + '원',
//                           style: whiteSmallShadowStyle,
//                         )
//                       ]),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }

class SwipeCardAlignment extends StatefulWidget {
  SwipeCard item;
  int index;
  List<dynamic> images = new List<dynamic>();
  SwipeCardAlignment(SwipeCard _item, int _index) {
    print("NEW");
    item = _item;
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
    print("WTF!");
    for (int i = 0; i < widget.images.length; i++) {
      precacheImage(widget.images[i].image, context);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD");
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
                  child: widget.images[widget.index],
                  // child: CachedNetworkImage(
                  //     imageUrl: item.image_urls[index],
                  //     httpHeaders: {
                  //       HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                  //     },
                  //     fit: BoxFit.cover),
                ),
              ),
              //   child: CachedNetworkImage(
              //       imageUrl: widget.item.image_urls[widget.index],
              //       httpHeaders: {
              //         HttpHeaders.refererHeader: "http://api-stride.com:5000/"
              //       },
              //       fit: BoxFit.cover),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                    children: List.generate(widget.item.length, (idx) {
                  if (widget.item.length == 1) return Container();
                  return idx == widget.index
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
              Container(
                alignment: Alignment.bottomLeft,
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
                        Text(
                          widget.item.product_name, //'로드리 스커트',
                          style: whiteShadowStyle,
                        ),
                        Text(
                          widget.item.price + '원',
                          style: whiteSmallShadowStyle,
                        )
                      ]),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.rulerVertical,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print(widget.item.product_size.free.length);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
