import 'package:flutter/material.dart';
import 'package:frontend/core/models/coordinate.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';

class LookBookDialog extends StatelessWidget {
  final Coordinate item;
  LookBookDialog(this.item);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(16),
      //title: Center(child: Text("나만의 룩")),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Image.network(
                    item.top_thumbnail_url,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        item.top_product_name,
                        style: subHeaderStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(item.top_price.toString()),
                    ],
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Image.network(
                    item.bottom_thumbnail_url,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        item.bottom_product_name,
                        style: subHeaderStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(item.bottom_price.toString()),
                    ],
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
