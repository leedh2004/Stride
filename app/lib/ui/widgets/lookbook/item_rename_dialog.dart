import 'dart:ui';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LookBookItemRenameDialog extends StatefulWidget {
  LookBookModel model;
  int id;
  LookBookItemRenameDialog(this.model, this.id);
  @override
  _LookBookItemRenameDialogState createState() =>
      _LookBookItemRenameDialogState();
}

class _LookBookItemRenameDialogState extends State<LookBookItemRenameDialog> {
  TextEditingController _renameTextController = TextEditingController();

  bool change = false;
  var buttonColor = backgroundColor;
  var renameButtonColor = Color(0xFF2B3341);
  bool busy = false;

  @override
  Widget build(BuildContext context) {
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
                      '아이템 이름 수정',
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
                    if (text.length == 0) {
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
                  controller: _renameTextController,
                  onSubmitted: (String text) async {
                    if (busy == false) {
                      busy = true;
                      if (text.length == 0) return;
                      widget.model
                          .rename(widget.id, _renameTextController.text);
                      Navigator.pop(context);
                      // setState(() {});
                      busy = false;
                    }
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "수정할 이름을 입력하세요."),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                child: Text(
                  '룩북 이름은 10글자 이내로 제한됩니다.',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (busy == false) {
                    busy = true;
                    if (_renameTextController.text.length == 0) return;
                    widget.model.rename(widget.id, _renameTextController.text);
                    busy = false;
                    Navigator.pop(context);
                    // setState(() {});
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
