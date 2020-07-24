import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text("정말로 삭제하시겠습니까?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, "remove");
            },
            child: Text('확인')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'))
      ],
    );
  }
}
