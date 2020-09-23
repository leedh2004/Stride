import 'package:app/ui/shared/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class FolderTextButton extends StatelessWidget {
  var folderKey;
  var model;
  String folderName;
  bool enable;

  FolderTextButton(model, folderName, folderKey, enable) {
    this.model = model;
    this.folderName = folderName;
    this.folderKey = folderKey;
    this.enable = enable;
  }

  @override
  Widget build(BuildContext context) {
    return enable
        ? InkWell(
            onTap: () {
              model.changeFolder(folderKey);
              Stride.analytics.logEvent(name: "DRESSROOM_FOLDER_CHANGE");
            },
            child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                constraints: BoxConstraints(minWidth: 50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black12)),
                child: Center(child: Text('${folderName}'))))
        : InkWell(
            onTap: () {
              model.changeFolder(folderKey);
            },
            child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                constraints: BoxConstraints(minWidth: 50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black),
                child: Center(
                    child: Text(
                  '${folderName}',
                  style: whiteStyle,
                ))));
  }
}
