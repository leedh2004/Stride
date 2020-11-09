import 'package:app/core/models/product_size.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/size.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

Map<String, String> pants = {
  "총장": "length",
  "허리": "waist",
  "엉덩이": "hip",
  "허벅지": "thigh",
  "밑단": "hem",
  "밑위": "rise",
};

Map<String, String> skirt = {
  "총장": "length",
  "허리": "waist",
  "엉덩이": "hip",
  "밑단": "hem",
};

Map<String, String> dress = {
  "총장": "length",
  "어깨": "shoulder",
  "가슴": "bust",
  "허리": "waist",
  "소매길이": "arm_length"
};
Map<String, String> top = {
  "총장": "length",
  "어깨": "shoulder",
  "가슴": "bust",
  "소매길이": "arm_length"
};

Map<String, String> outer = {
  "총장": "length",
  "어깨": "shoulder",
  "가슴": "bust",
  "소매길이": "arm_length"
};

class SizeDialog extends StatefulWidget {
  RecentItem item;
  ProductSize product_size;
  List<String> keys;
  Map<String, String> mapper;
  List<String> header;
  Map<String, Size> sizeMapper = new Map();

  SizeDialog(RecentItem _item) {
    item = _item;
    product_size = _item.product_size;
    keys = product_size.size.keys.toList();
    if (item.type == 'top')
      mapper = top;
    else if (item.type == 'pants')
      mapper = pants;
    else if (item.type == 'skirt')
      mapper = skirt;
    else if (item.type == 'dress')
      mapper = dress;
    else if (item.type == 'outer') mapper = outer;
    header = mapper.keys.toList();
    for (var h in header) print(h);
    print(keys);
    for (String key in keys) {
      sizeMapper[key] = product_size.size[key];
    }
  }
  @override
  _SizeDialogState createState() => _SizeDialogState();
}

class _SizeDialogState extends State<SizeDialog> {
  bool display = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: '사이즈 정보',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF616576),
                      fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' (단면, cm)',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(98, 101, 117, 0.5),
                      fontWeight: FontWeight.w700),
                ),
              ]))),
          SizedBox(
            height: 14,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //defaultColumnWidth: FractionColumnWidth(0.12),
            children: [
              TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF3F4F8),
                  ),
                  children: [
                    Container(
                      height: 40,
                      child: Center(
                        child: Text(
                          'SIZE',
                          style: tableHeaderText,
                        ),
                      ),
                    ),
                    ...List.generate(widget.header.length, (index) {
                      return (Center(
                        child: Text(
                          '${widget.header[index]}',
                          style: tableHeaderText,
                        ),
                      ));
                    })
                  ]),
              ...List.generate(widget.keys.length, (index) {
                return (TableRow(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
                    children: [
                      Container(
                          height: 40,
                          child: Padding(
                              padding: EdgeInsets.all(0),
                              child: ColorSizeBox(widget.keys[index]))),
                      ...List.generate(widget.header.length, (idx) {
                        var ret = widget.sizeMapper[widget.keys[index]]
                            .map[widget.mapper[widget.header[idx]]]
                            .toString();
                        if (ret == '0.0') ret = '-';
                        if (ret.endsWith('.0'))
                          ret = ret.substring(0, ret.length - 2);
                        return (Center(
                            child: Text(
                          '$ret',
                          style: tableCellText,
                        )));
                      })
                    ]));
              }),
            ],
          ),
        ]),
      ),
    );

    // return Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body: OpacityAnimatedWidget.tween(
    //     opacityEnabled: 1,
    //     opacityDisabled: 0,
    //     duration: Duration(milliseconds: 300),
    //     enabled: display,
    //     child: SizedBox.expand(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Expanded(
    //               child: InkWell(
    //             enableFeedback: false,
    //             canRequestFocus: false,
    //             onTap: () async {
    //               setState(() {
    //                 display = false;
    //               });
    //               await Future.delayed(Duration(milliseconds: 300));
    //               Navigator.maybePop(context);
    //             },
    //             child: Container(
    //               color: Color.fromRGBO(0, 0, 0, 0.4),
    //             ),
    //           )),
    //           Container(
    //             color: Colors.white,
    //             child: Center(
    //               child: Column(children: [
    //                 Stack(alignment: Alignment.center, children: [
    //                   Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Padding(
    //                         padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
    //                         child: Text('(단면, cm)')),
    //                   ),
    //                   Align(
    //                     alignment: Alignment.centerRight,
    //                     child: FlatButton(
    //                       onPressed: () async {
    //                         setState(() {
    //                           display = false;
    //                         });
    //                         await Future.delayed(Duration(milliseconds: 300));

    //                         Navigator.maybePop(context);
    //                       },
    //                       //elevation: 2.0,
    //                       color: Color.fromRGBO(240, 240, 240, 1),
    //                       child: SvgPicture.asset(
    //                         'images/times.svg',
    //                         width: 16.0,
    //                         color: Colors.black,
    //                       ),
    //                       shape: CircleBorder(),
    //                     ),
    //                   ),
    //                 ]),
    //                 Padding(
    //                   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                   child: Table(
    //                     defaultVerticalAlignment:
    //                         TableCellVerticalAlignment.middle,
    //                     //defaultColumnWidth: FractionColumnWidth(0.12),
    //                     children: [
    //                       TableRow(
    //                           decoration: BoxDecoration(
    //                             color: Color.fromRGBO(240, 240, 240, 1),
    //                           ),
    //                           children: [
    //                             Container(
    //                               height: 60,
    //                               child: Center(
    //                                 child: Text(
    //                                   'SIZE',
    //                                   style: tableHeaderSizeText,
    //                                 ),
    //                               ),
    //                             ),
    //                             ...List.generate(widget.header.length, (index) {
    //                               return (Center(
    //                                 child: Text(
    //                                   '${widget.header[index]}',
    //                                   style: tableHeaderText,
    //                                 ),
    //                               ));
    //                             })
    //                           ]),
    //                       ...List.generate(widget.keys.length, (index) {
    //                         return (TableRow(
    //                             decoration: BoxDecoration(
    //                                 border: Border(
    //                                     bottom: BorderSide(
    //                                         color: Theme.of(context)
    //                                             .dividerColor))),
    //                             children: [
    //                               Container(
    //                                   height: 40,
    //                                   child: Padding(
    //                                       padding: EdgeInsets.all(4),
    //                                       child: ColorSizeBox(
    //                                           widget.keys[index]))),
    //                               ...List.generate(widget.header.length, (idx) {
    //                                 var ret = widget
    //                                     .sizeMapper[widget.keys[index]]
    //                                     .map[widget.mapper[widget.header[idx]]]
    //                                     .toString();
    //                                 if (ret == '0.0') ret = '-';
    //                                 if (ret.endsWith('.0'))
    //                                   ret = ret.substring(0, ret.length - 2);
    //                                 return (Center(
    //                                     child: Text(
    //                                   '$ret',
    //                                   style: tableCellText,
    //                                 )));
    //                               })
    //                             ]));
    //                       }),
    //                     ],
    //                   ),
    //                 ),
    //               ]),
    //             ),
    //           ),
    //           Expanded(
    //               child: InkWell(
    //             enableFeedback: false,
    //             canRequestFocus: false,
    //             onTap: () async {
    //               setState(() {
    //                 display = false;
    //               });
    //               await Future.delayed(Duration(milliseconds: 300));

    //               Navigator.maybePop(context);
    //             },
    //             child: Container(
    //               color: Color.fromRGBO(0, 0, 0, 0.4),
    //             ),
    //           )),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// class SizeDialog extends StatelessWidget {
//   RecentItem widget.item;
//   ProductSize product_size;
//   List<String> keys;
//   Map<String, String> mapper;
//   List<String> header;
//   Map<String, Size> sizeMapper = new Map();

//   SizeDialog(RecentItem _item) {
//     item = _item;
//     product_size = _item.product_size;
//     keys = product_size.size.keys.toList();
//     if (item.type == 'top')
//       mapper = top;
//     else if (item.type == 'pants')
//       mapper = pants;
//     else if (item.type == 'skirt')
//       mapper = skirt;
//     else if (item.type == 'dress') mapper = dress;
//     header = mapper.keys.toList();
//     for (var h in header) print(h);
//     print(keys);
//     for (String key in keys) {
//       sizeMapper[key] = product_size.size[key];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Stride.logEvent(name: "SWIPE_SHOW_SIZE", parameters: {
//       'itemId': item.product_id.toString(),
//       'itemName': item.product_name,
//       'itemCategory': item.shop_name
//     });
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: OpacityAnimatedWidget.tween(
//         opacityEnabled: 1,
//         opacityDisabled: 0,
//         enabled: true,
//         child: SizedBox.expand(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                   child: InkWell(
//                 enableFeedback: false,
//                 canRequestFocus: false,
//                 onTap: () {
//                   Navigator.maybePop(context);
//                 },
//                 child: Container(
//                   color: Color.fromRGBO(0, 0, 0, 0.4),
//                 ),
//               )),
//               Container(
//                 color: Colors.white,
//                 child: Center(
//                   child: Column(children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: FlatButton(
//                         onPressed: () {
//                           Navigator.maybePop(context);
//                         },
//                         //elevation: 2.0,
//                         color: Color.fromRGBO(240, 240, 240, 1),
//                         child: SvgPicture.asset(
//                           'images/times.svg',
//                           width: 16.0,
//                           color: Colors.black,
//                         ),
//                         shape: CircleBorder(),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       child: Table(
//                         defaultVerticalAlignment:
//                             TableCellVerticalAlignment.middle,
//                         //defaultColumnWidth: FractionColumnWidth(0.12),
//                         children: [
//                           TableRow(
//                               decoration: BoxDecoration(
//                                 color: Color.fromRGBO(240, 240, 240, 1),
//                               ),
//                               children: [
//                                 Container(
//                                   height: 60,
//                                   child: Center(
//                                     child: Text(
//                                       'SIZE',
//                                       style: tableHeaderSizeText,
//                                     ),
//                                   ),
//                                 ),
//                                 ...List.generate(header.length, (index) {
//                                   return (Center(
//                                     child: Text(
//                                       '${header[index]}',
//                                       style: tableHeaderText,
//                                     ),
//                                   ));
//                                 })
//                               ]),
//                           ...List.generate(keys.length, (index) {
//                             return (TableRow(
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                         bottom: BorderSide(
//                                             color: Theme.of(context)
//                                                 .dividerColor))),
//                                 children: [
//                                   Container(
//                                       height: 40,
//                                       child: Padding(
//                                           padding: EdgeInsets.all(4),
//                                           child: ColorSizeBox(keys[index]))),
//                                   ...List.generate(header.length, (idx) {
//                                     double ret = sizeMapper[keys[index]]
//                                         .map[mapper[header[idx]]];
//                                     if (ret == 0) {
//                                       return Center(
//                                           child: Text(
//                                         '-',
//                                         style: tableCellText,
//                                       ));
//                                     }
//                                     return (Center(
//                                         child: Text(
//                                       '$ret',
//                                       style: tableCellText,
//                                     )));
//                                   })
//                                 ]));
//                           }),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//               Expanded(
//                   child: InkWell(
//                 enableFeedback: false,
//                 canRequestFocus: false,
//                 onTap: () {
//                   Navigator.maybePop(context);
//                 },
//                 child: Container(
//                   color: Color.fromRGBO(0, 0, 0, 0.4),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

Widget ColorSizeBox(String size) {
  return Container(
      height: 40,
      child: Center(
          child: Text(size.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Color(0xFF8569EF)))));
  // if (size == 'free') {
  //   return Container(
  //       color: semiPurple,
  //       height: 40,
  //       child: Center(child: Text(size.toUpperCase(), style: tableCellText)));
  // } else if (size == 'xs') {
  //   return Container(
  //       color: semiPurple,
  //       height: 40,
  //       child: Center(child: Text(size.toUpperCase(), style: tableCellText)));
  // } else if (size == 's') {
  //   return Container(
  //       color: semiPurple,
  //       height: 40,
  //       child: Center(child: Text(size.toUpperCase(), style: tableCellText)));
  // } else if (size == 'm') {
  //   return Container(
  //       color: backgroundColor,
  //       height: 40,
  //       child:
  //           Center(child: Text(size.toUpperCase(), style: tableCellWhiteText)));
  // } else if (size == 'l') {
  //   return Container(
  //       color: semiBlack,
  //       height: 40,
  //       child:
  //           Center(child: Text(size.toUpperCase(), style: tableCellWhiteText)));
  // } else if (size == 'xl') {}
  // return Container(
  //     color: semiBlack,
  //     height: 40,
  //     child:
  //         Center(child: Text(size.toUpperCase(), style: tableCellWhiteText)));
}

const semiPurple = Color.fromRGBO(227, 220, 242, 1);
const semiBlack = Color.fromRGBO(55, 55, 55, 1);

const tableHeaderSizeText =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
const tableHeaderText = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF888C93));
const tableCellText = TextStyle(fontSize: 11, color: Color(0xFF323334));
const tableCellWhiteText =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white);
