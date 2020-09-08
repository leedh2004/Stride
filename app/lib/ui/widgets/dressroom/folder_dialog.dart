import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderDialog extends StatefulWidget {
  DressRoomModel model;
  FolderDialog(this.model);
  @override
  _FolderDialogState createState() => _FolderDialogState();
}

class _FolderDialogState extends State<FolderDialog> {
  String page = "default";
  TextEditingController _textController = TextEditingController();
  TextEditingController _renameTextController = TextEditingController();

  var folder;
  var folderIds;
  var folderNames;
  var curFolderId = 0;
  bool change = false;

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    folder = Provider.of<DressRoomService>(context).folder;
    folderIds = folder.keys.toList();
    folderNames = folder.values.toList();
    if (page == "default") {
      showWidget = Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child:
            ListView(padding: EdgeInsets.all(0), shrinkWrap: true, children: [
          Stack(alignment: Alignment.center, children: [
            Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                    child: Image.asset(
                      'images/left-arrow.png',
                      width: 15,
                      height: 15,
                    ),
                    //icon: FaIcon(FontAwesomeIcons.folderPlus),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            Align(
                alignment: Alignment.center,
                child: widget.model.selectedIdx.isEmpty
                    ? Text(
                        '폴더 보기',
                        style: headerStyle,
                      )
                    : Text(
                        '폴더 이동',
                        style: headerStyle,
                      )),
            Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    child: Image.asset(
                      'images/folder_plus.png',
                      width: 25,
                      height: 25,
                    ),
                    //icon: FaIcon(FontAwesomeIcons.folderPlus),
                    onPressed: () {
                      setState(() {
                        page = "folderCreate";
                      });
                    }))
          ]),
          ...List.generate(folderNames.length, (index) {
            String folderName = folderNames[index];
            if (folderName == 'default') folderName = '♥';
            return Column(children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                onTap: () {
                  if (widget.model.selectedIdx.isNotEmpty) {
                    widget.model.moveFolder(folderIds[index]);
                    Navigator.pop(context);
                  }
                },
                leading: index != 0
                    ? FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Image.asset(
                          'images/remove.png',
                          width: 25,
                          height: 25,
                        ),
                        // icon: FaIcon(FontAwesomeIcons.timesCircle),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('AlertDialog Demo'),
                                  content: Text("정말로 삭제하시겠습니까?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        await widget.model
                                            .deleteFolder(folderIds[index]);
                                        setState(() {
                                          //just for rebuild
                                        });
                                        Navigator.pop(context, "Cancel");
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context, "Cancel");
                                      },
                                    ),
                                  ],
                                );
                              });
                        })
                    : FlatButton(
                        child: SvgPicture.asset(
                          'images/edit.svg',
                          color: Colors.transparent,
                          width: 25,
                          height: 25,
                        ),
                        onPressed: () {}),
                trailing: index != 0
                    ? FlatButton(
                        child: SvgPicture.asset(
                          'images/edit.svg',
                          color: Colors.black87,
                          width: 25,
                          height: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            curFolderId = folderIds[index];
                            page = 'folderRename';
                          });
                        })
                    : FlatButton(
                        child: SvgPicture.asset(
                          'images/edit.svg',
                          color: Colors.transparent,
                          width: 25,
                          height: 25,
                        ),
                        onPressed: () {}),
                title: Text('$folderName'),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Divider(
                    height: 1,
                  ))
            ]);
          })
        ]),
      );
    } else if (page == 'folderCreate') {
      showWidget = Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    '폴더 추가',
                    style: headerStyle,
                  ),
                  leading: FlatButton(
                      child: Image.asset(
                        'images/left-arrow.png',
                        width: 15,
                        height: 15,
                      ),
                      //icon: FaIcon(FontAwesomeIcons.folderPlus),
                      onPressed: () {
                        setState(() {
                          page = "default";
                        });
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    autofocus: true,
                    controller: _textController,
                    onSubmitted: (String text) async {
                      await widget.model.createFolder(_textController.text);
                      setState(() {
                        page = "default";
                      });
                      //Navigator.pop(context);
                    },
                    decoration:
                        InputDecoration.collapsed(hintText: "폴더명을 입력해주세요"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                  child: Text(
                    '폴더 이름은 열 글자 이내로 제한됩니다.',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    print(_textController.text);
                    await widget.model.createFolder(_textController.text);
                    setState(() {
                      page = "default";
                    });
                    //Navigator.pop(context);
                  },
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  color: backgroundColor,
                  child: Text(
                    '확인',
                    style: whiteStyle,
                  ),
                )
              ],
            )),
      );
    } else if (page == 'folderRename') {
      showWidget = Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    '이름 수정',
                    style: headerStyle,
                  ),
                  leading: FlatButton(
                      child: Image.asset(
                        'images/left-arrow.png',
                        width: 15,
                        height: 15,
                      ),
                      //icon: FaIcon(FontAwesomeIcons.folderPlus),
                      onPressed: () {
                        setState(() {
                          page = "default";
                        });
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _renameTextController,
                    onSubmitted: (String text) async {
                      await widget.model.renameFolder(
                          curFolderId, _renameTextController.text);
                      setState(() {
                        page = "default";
                      });
                    },
                    decoration: InputDecoration.collapsed(hintText: "새로운 이름"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                  child: Text(
                    '폴더 이름은 열 글자 이내로 제한됩니다.',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    await widget.model
                        .renameFolder(curFolderId, _renameTextController.text);
                    setState(() {
                      page = "default";
                    });
                  },
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  color: backgroundColor,
                  child: Text(
                    '확인',
                    style: whiteStyle,
                  ),
                )
              ],
            )),
      );
    }
    return showWidget;
  }
}

const headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
