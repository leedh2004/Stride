import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderCreateDialog extends StatefulWidget {
  DressRoomModel model;
  FolderCreateDialog(this.model);
  @override
  _FolderCreateDialogState createState() => _FolderCreateDialogState();
}

class _FolderCreateDialogState extends State<FolderCreateDialog> {
  TextEditingController _textController = TextEditingController();

  var folder;
  var folderIds;
  var folderNames;
  var curFolderId = 0;
  bool change = false;
  var buttonColor = backgroundColor;
  var renameButtonColor = gray;
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    folder = Provider.of<DressRoomService>(context).folder;
    folderIds = folder.keys.toList();
    folderNames = folder.values.toList();

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 14,
              ),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  color: Color(0xFFD3D4EA),
                ),
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Text(
                      '폴더 생성',
                      style: headerStyle,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD3D4EA))),
                padding: EdgeInsets.all(12),
                child: TextField(
                  onChanged: (text) {
                    if (folderNames.contains(text) || text.length == 0) {
                      setState(() {
                        renameButtonColor = gray;
                      });
                    } else {
                      setState(() {
                        renameButtonColor = Color(0xFF2B3341);
                      });
                    }
                  },
                  autofocus: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: _textController,
                  onSubmitted: (String text) async {
                    if (busy == false) {
                      busy = true;
                      if (folderNames.contains(text) || text.length == 0)
                        return;
                      widget.model
                          .renameFolder(curFolderId, _textController.text);
                      setState(() {});
                      busy = false;
                    }
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "폴더명을 입력해주세요"),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                child: Text(
                  '폴더 이름은 10글자 이내로 제한됩니다.',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (busy == false) {
                    busy = true;
                    print(_textController.text);
                    if (folderNames.contains(_textController.text) ||
                        _textController.text.length == 0) {
                      return;
                    }
                    await widget.model.createFolder(_textController.text);
                    setState(() {});
                    busy = false;
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(24),
                  height: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: renameButtonColor),
                  child: Center(
                    child: Text(
                      '완료',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

const headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
