import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class LookBookCreateDialog extends StatefulWidget {
  RecentItem top, bottom;
  LookBookCreateDialog(this.top, this.bottom);
  @override
  _LookBookCreateDialogState createState() => _LookBookCreateDialogState();
}

class _LookBookCreateDialogState extends State<LookBookCreateDialog> {
  TextEditingController _renameTextController = TextEditingController();

  var renameButtonColor = Color(0xFF2B3341);

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
                      '룩북 만들기',
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
                  autofocus: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: _renameTextController,
                  onSubmitted: (String text) async {
                    Stride.logEvent(name: "DRESSROOM_MAKE_COORDINATE");
                    await Provider.of<LookBookService>(context, listen: false)
                        .addItem(widget.top, widget.bottom,
                            _renameTextController.text);
                    // lookbook_flush.show(context);
                    Navigator.maybePop(context);
                  },
                  decoration: InputDecoration.collapsed(hintText: "새로운 이름"),
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
                  Stride.logEvent(name: "DRESSROOM_MAKE_COORDINATE");
                  await Provider.of<LookBookService>(context, listen: false)
                      .addItem(widget.top, widget.bottom,
                          _renameTextController.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
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
