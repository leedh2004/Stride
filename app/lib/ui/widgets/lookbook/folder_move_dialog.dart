import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LookBookFolderMoveDialog extends StatefulWidget {
  int id;
  LookBookModel model;
  LookBookFolderMoveDialog(this.model, this.id);
  @override
  _LookBookFolderMoveDialogState createState() =>
      _LookBookFolderMoveDialogState();
}

class _LookBookFolderMoveDialogState extends State<LookBookFolderMoveDialog> {
  int selected = 0;
  var items;
  var folder;
  var folderIds;
  var folderNames;
  var curFolderId = 0;
  bool change = false;
  var buttonColor = backgroundColor;
  var renameButtonColor = gray;
  bool busy = false;

  Widget twoImg(List<Coordinate> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: items[0].top.thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
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

  Widget threeImg(List<Coordinate> items) {
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
    folder = Provider.of<LookBookService>(context).folder;
    items = Provider.of<LookBookService>(context).items;

    folderIds = folder.keys.toList();
    folderNames = folder.values.toList();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '폴더 이동',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFF4F4FC)),
                      child: Center(
                        child: Text(
                          '선택된 아이템을 이동할 폴더를 선택해주세요.',
                          style: TextStyle(color: Color(0xFF8569EF)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ...List.generate(folderNames.length, (index) {
                            List<Coordinate> item = items[folderIds[index]];
                            String name = folderNames[index];
                            if (name == 'default') name = '나의 룩북';
                            return ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 24),
                                leading: Container(
                                    width: 64,
                                    height: 64,
                                    child: item.length > 1
                                        ? threeImg(item)
                                        : item.length > 0
                                            ? twoImg(item)
                                            : Container()),
                                title: Text(
                                  name,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                trailing: Radio(
                                  value: index,
                                  groupValue: selected,
                                  activeColor: Color(0xFF8569EF),
                                  onChanged: (value) {
                                    setState(() {
                                      selected = value;
                                    });
                                  },
                                ));
                          })
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        widget.model.moveFolder(folderIds[selected], widget.id);
                        Navigator.maybePop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFF2B3341)),
                        child: Center(
                          child: Text(
                            '선택완료',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

const headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
