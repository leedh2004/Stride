import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderMoveDialog extends StatefulWidget {
  DressRoomModel model;
  FolderMoveDialog(this.model);
  @override
  _FolderMoveDialogState createState() => _FolderMoveDialogState();
}

class _FolderMoveDialogState extends State<FolderMoveDialog> {
  TextEditingController _renameTextController = TextEditingController();
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

  Widget twoImg(List<RecentItem> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: items[0].thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: items[1].thumbnail_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget threeImg(List<RecentItem> items) {
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
                    imageUrl: items[1].thumbnail_url,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: items[2].thumbnail_url,
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

  Widget oneImg(List<RecentItem> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: CachedNetworkImage(
          imageUrl: items[0].thumbnail_url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    folder = Provider.of<DressRoomService>(context).folder;
    items = Provider.of<DressRoomService>(context).items;

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
                            List<RecentItem> item = items[folderIds[index]];
                            String name = folderNames[index];
                            if (name == 'default') name = '내가 찜한 옷';
                            return ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 24),
                                leading: Container(
                                  width: 64,
                                  height: 64,
                                  child: item.length > 2
                                      ? threeImg(item)
                                      : item.length > 1
                                          ? twoImg(item)
                                          : item.length > 0
                                              ? oneImg(item)
                                              : Container(),
                                ),
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
                        if (widget.model.selectedIdx.isNotEmpty) {
                          widget.model.moveFolder(folderIds[selected]);
                          Navigator.maybePop(context);
                        }
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
