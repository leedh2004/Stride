import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/dressroom/item_view.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:app/ui/views/lookbook/item.view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class FolderLookBookTextButton extends StatelessWidget {
  var folderKey;
  LookBookModel model;
  String folderName;
  List<Coordinate> items;

  FolderLookBookTextButton(model, folderName, folderKey, items) {
    this.model = model;
    this.folderName = folderName;
    this.folderKey = folderKey;
    this.items = items;
  }

  Widget twoImg() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              color: backgroundColor,
              child: CachedNetworkImage(
                imageUrl: items[0].top.thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: backgroundColor,
              child: CachedNetworkImage(
                imageUrl: items[0].bottom.thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget threeImg() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: items[0].top.thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: items[0].bottom.thumbnail_url,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: items[1].top.thumbnail_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          model.changeFolder(folderKey);
          Stride.analytics.logEvent(name: "DRESSROOM_FOLDER_CHANGE");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LookBookItemView(folderName);
          }));
        },
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: items.length > 1
                    ? threeImg()
                    : items.length > 0
                        ? twoImg()
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(8),
                        //     child: Container(
                        //       width: double.infinity,
                        //       height: double.infinity,
                        //       child: CachedNetworkImage(
                        //         imageUrl: items[0].thumbnail_url,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFFAF9FC)),
                          )),
            SizedBox(
              height: 16,
            ),
            Text(
              '${folderName}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text('상품 ${items.length}개')
          ]),
          folderKey == 0
              ? Padding(
                  padding: EdgeInsets.all(9),
                  child: Image.asset(
                    'assets/swipe_heart.png',
                    width: 25,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(9),
                  child: Image.asset(
                    'assets/purple_folder.png',
                    width: 25,
                  ),
                )
        ]));
  }
}
