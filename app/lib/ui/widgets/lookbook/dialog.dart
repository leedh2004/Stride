import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/dressroom/product_dialog.dart';
import 'package:app/ui/widgets/lookbook/product_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LookBookDialog extends StatelessWidget {
  final Coordinate item;
  LookBookDialog(this.item);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ProductTable(item.top),
            UIHelper.verticalSpaceSmall,
            ProductTable(item.bottom),
          ],
        ),
      ),
    );
  }
}
