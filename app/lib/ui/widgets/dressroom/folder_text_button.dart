import 'package:app/core/models/recentItem.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/dressroom/item_view.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class FolderTextButton extends StatelessWidget {
  var folderKey;
  var model;
  String folderName;
  List<RecentItem> items;

  FolderTextButton(model, folderName, folderKey, items) {
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
                imageUrl: items[0].thumbnail_url,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: backgroundColor,
              child: CachedNetworkImage(
                imageUrl: items[1].thumbnail_url,
                fit: BoxFit.fitHeight,
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
                imageUrl: items[0].thumbnail_url,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: items[1].thumbnail_url,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: items[2].thumbnail_url,
                    fit: BoxFit.fitHeight,
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
            return DressRoomItemView(this.items);
          }));
        },
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: items.length > 0
                    ? threeImg()
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
                        child: Center(child: Text('No Image')),
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
          Padding(
            padding: EdgeInsets.all(9),
            child: Image.asset(
              'assets/swipe_heart.png',
              width: 25,
            ),
          )
        ]));
  }
}
