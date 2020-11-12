import 'dart:io';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/product_size.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/size.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDialog extends StatefulWidget {
  RecentItem item;
  ProductSize product_size;
  List<String> keys;
  Map<String, String> mapper;
  List<String> header;
  Map<String, Size> sizeMapper = new Map();
  String current;
  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  bool display = true;
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget.tween(
      opacityEnabled: 1,
      opacityDisabled: 0,
      duration: Duration(milliseconds: 300),
      enabled: display,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: InkWell(
                enableFeedback: false,
                canRequestFocus: false,
                onTap: () async {
                  setState(() {
                    display = false;
                  });
                  await Future.delayed(Duration(milliseconds: 300));
                  Navigator.maybePop(context);
                },
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  child: Column(
                    children: [
                      Image.asset('tap.png'),
                      Image.asset('swipe.png'),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

const shopInfoHighlightText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold, color: backgroundColor);
const shopInfoText = TextStyle(fontSize: 16);
const tableHeaderSizeText =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
const tableHeaderText = TextStyle(fontSize: 14);
const tableCellText = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
const sizeCellText = TextStyle(fontSize: 12);
const sizeCellWhiteText = TextStyle(fontSize: 12, color: Colors.white);
