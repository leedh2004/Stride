import 'dart:io';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/product_size.dart';
import 'package:app/core/models/size.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class ProductDialog extends StatefulWidget {
  Product item;
  ProductSize product_size;
  List<String> keys;
  Map<String, String> mapper;
  List<String> header;
  Map<String, Size> sizeMapper = new Map();
  String current;

  ProductDialog(Product _item) {
    item = _item;
    product_size = _item.product_size;
    keys = product_size.size.keys.toList();
    if (item.type == 'top')
      mapper = top;
    else if (item.type == 'pants')
      mapper = pants;
    else if (item.type == 'skirt')
      mapper = skirt;
    else if (item.type == 'dress') mapper = dress;
    header = mapper.keys.toList();
    for (var h in header) print(h);
    print(keys);
    for (String key in keys) {
      sizeMapper[key] = product_size.size[key];
    }
    current = keys[0];
  }

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  @override
  Widget build(BuildContext context) {
    Stride.analytics.logEvent(name: "DRESS_ROOM_SHOW_SIZE", parameters: {
      'itemId': widget.item.product_id.toString(),
      'itemName': widget.item.product_name,
      'itemCategory': widget.item.shop_name
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: InkWell(
              enableFeedback: false,
              canRequestFocus: false,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.4),
              ),
            )),
            Container(
              color: Colors.white,
              child: Column(children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: Color.fromRGBO(240, 240, 240, 1),
                    child: FaIcon(
                      FontAwesomeIcons.times,
                      size: 16.0,
                      color: Colors.black,
                    ),
                    shape: CircleBorder(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: CachedNetworkImage(
                                  imageUrl: widget.item.thumbnail_url,
                                  fit: BoxFit.cover,
                                  httpHeaders: {
                                    HttpHeaders.refererHeader:
                                        "http://api-stride.com:5000/"
                                  }),
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.item.shop_name}',
                                  style: shopInfoText,
                                ),
                                Text('${widget.item.product_name}',
                                    style: shopInfoText),
                                UIHelper.verticalSpaceMedium,
                                Text('${widget.item.price}원',
                                    style: shopInfoText),
                                UIHelper.verticalSpaceMedium,
                                Table(
                                  children: [
                                    TableRow(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(240, 240, 240, 1),
                                        ),
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            child: Row(children: [
                                              Expanded(
                                                flex: 1,
                                                child: Center(
                                                  child: Text(
                                                    'SIZE',
                                                    style: tableHeaderSizeText,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Wrap(
                                                    direction: Axis.horizontal,
                                                    children: List.generate(
                                                        widget.keys.length,
                                                        (index) {
                                                      var ret =
                                                          widget.keys[index];
                                                      if (ret ==
                                                          widget.current) {
                                                        return InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 35,
                                                              height: 30,
                                                              margin: EdgeInsets
                                                                  .all(2),
                                                              color:
                                                                  backgroundColor,
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2),
                                                                  child: Text(
                                                                    '${ret.toUpperCase()}',
                                                                    style:
                                                                        sizeCellWhiteText,
                                                                  ),
                                                                ),
                                                              ),
                                                            ));
                                                      } else {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              widget.current =
                                                                  ret;
                                                            });
                                                          },
                                                          child: Container(
                                                              width: 35,
                                                              height: 30,
                                                              color: Colors
                                                                  .black26,
                                                              margin: EdgeInsets
                                                                  .all(2),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child: Center(
                                                                    child: Text(
                                                                  '${ret.toUpperCase()}',
                                                                  style:
                                                                      sizeCellText,
                                                                )),
                                                              )),
                                                        );
                                                      }
                                                      ;
                                                    })),
                                              ),
                                            ]),
                                          ),
                                        ]),
                                    ...List.generate(widget.header.length,
                                        (index) {
                                      var ret = widget
                                              .sizeMapper[widget.current].map[
                                          widget.mapper[widget.header[index]]];
                                      return TableRow(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Theme.of(context)
                                                          .dividerColor))),
                                          children: [
                                            (Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      '${widget.header[index]}',
                                                      style: tableHeaderText,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      '$ret',
                                                      style: tableHeaderText,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                            )),
                                          ]);
                                    }),
                                  ],
                                ),
                              ]),
                        ),
                      ]),
                ),
              ]),
            ),
            Expanded(
                child: InkWell(
              enableFeedback: false,
              canRequestFocus: false,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.4),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

const shopInfoText = TextStyle(fontSize: 16);
const tableHeaderSizeText =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
const tableHeaderText = TextStyle(fontSize: 14);
const tableCellText = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
const sizeCellText = TextStyle(fontSize: 12);
const sizeCellWhiteText = TextStyle(fontSize: 12, color: Colors.white);
