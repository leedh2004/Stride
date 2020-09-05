import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:flutter/material.dart';
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
      showWidget = ListView(shrinkWrap: true, children: [
        Container(
            child: Stack(alignment: Alignment.center, children: [
          Align(
              alignment: Alignment.center,
              child: widget.model.selectedIdx.isEmpty
                  ? Text(
                      '폴더 보기',
                      style: subHeaderStyle,
                    )
                  : Text(
                      '폴더 이동',
                      style: subHeaderStyle,
                    )),
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.folderPlus),
                  onPressed: () {
                    setState(() {
                      page = "folderCreate";
                    });
                  }))
        ])),
        ...List.generate(folderNames.length, (index) {
          String folderName = folderNames[index];
          if (folderName == 'default') folderName = '기본 폴더';
          return ListTile(
            onTap: () {
              if (widget.model.selectedIdx.isNotEmpty) {
                widget.model.moveFolder(folderIds[index]);
                Navigator.pop(context);
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text('!!!'),
                // ));
              }
            },
            leading: IconButton(
                icon: FaIcon(FontAwesomeIcons.timesCircle),
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
                }),
            trailing: IconButton(
                icon: FaIcon(FontAwesomeIcons.pencilAlt),
                onPressed: () {
                  setState(() {
                    curFolderId = folderIds[index];
                    page = 'folderRename';
                  });
                }),
            title: Text('$folderName'),
          );
        })
      ]);
    } else if (page == 'folderCreate') {
      showWidget = Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  '폴더 추가',
                  style: subHeaderStyle,
                ),
                leading: IconButton(
                    icon: FaIcon(FontAwesomeIcons.backspace),
                    onPressed: () {
                      setState(() {
                        page = "default";
                      });
                    }),
              ),
              TextField(
                autofocus: true,
                controller: _textController,
                onSubmitted: (String text) async {
                  await widget.model.createFolder(_textController.text);
                  setState(() {
                    page = "default";
                  });
                  //Navigator.pop(context);
                },
                decoration: InputDecoration.collapsed(hintText: "폴더명을 입력해주세요"),
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
          ));
    } else if (page == 'folderRename') {
      showWidget = Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  '이름 수정',
                  style: subHeaderStyle,
                ),
                leading: IconButton(
                    icon: FaIcon(FontAwesomeIcons.backspace),
                    onPressed: () {
                      setState(() {
                        page = "default";
                      });
                    }),
              ),
              TextField(
                autofocus: true,
                controller: _renameTextController,
                onSubmitted: (String text) async {
                  await widget.model
                      .renameFolder(curFolderId, _renameTextController.text);
                  setState(() {
                    page = "default";
                  });
                },
                decoration: InputDecoration.collapsed(hintText: "새로운 이름"),
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
          ));
    }
    return showWidget;
  }
}
