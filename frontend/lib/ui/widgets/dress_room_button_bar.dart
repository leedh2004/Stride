import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/viewmodels/widgets/dress_room_model.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:provider/provider.dart';

import 'delete_alert_dialog.dart';

class DressRoomButtonBar extends StatelessWidget {
  final isAnyOneSelected;
  DressRoomButtonBar(this.isAnyOneSelected);

  @override
  Widget build(BuildContext context) {
    return isAnyOneSelected
        ? Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  color: backgroundColor,
                  onPressed: () {},
                  child: Text('Make', style: whiteStyle),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: backgroundColor,
                  padding: EdgeInsets.only(right: 30),
                  alignment: Alignment.centerRight,
                  icon: FaIcon(FontAwesomeIcons.trash),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteAlertDialog();
                        });
                    if (result == "remove") {
                      Provider.of<DressRoomModel>(context, listen: false)
                          .removeItem();
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(
                          '아이템이 정상적으로 삭제 되었습니다.',
                        ),
                        // action: SnackBarAction(
                        //   textColor: Colors.yellow,
                        //   label: '확인',
                        //   onPressed: () {
                        //     // Some code to undo the change.
                        //   },
                        // ),
                      );

                      // Find the Scaffold in the widget tree and use
                      // it to show a SnackBar.
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
            ],
          )
        : Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  color: Colors.black26,
                  onPressed: () {},
                  child: Text('Make', style: whiteStyle),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: Colors.black26,
                  padding: EdgeInsets.only(right: 30),
                  alignment: Alignment.centerRight,
                  icon: FaIcon(FontAwesomeIcons.trash),
                  onPressed: () {},
                ),
              ),
            ],
          );
  }
}
