import 'package:app/core/models/product.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/widgets/dressroom/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DressRoomButtonBar extends StatelessWidget {
  final DressRoomModel model;
  DressRoomButtonBar(this.model);

  @override
  Widget build(BuildContext context) {
    return model.isAnyOneSelected
        ? Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  color: backgroundColor,
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerRight,
                  icon: FaIcon(FontAwesomeIcons.solidFolder),
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                    padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
                    color: backgroundColor,
                    onPressed: () async {
                      List<Product> top = model.findSelectedTop();
                      List<Product> bottom = model.findSelectedBotoom();
                      showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          builder: (context, scrollController) =>
                              DressRoomSelectDialog(top, bottom));
                    },
                    child: Text(
                      'MAKE',
                      style: whiteStyle,
                    )
                    // child: Text('Make', style: whiteStyle),
                    ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    color: backgroundColor,
                    padding: EdgeInsets.only(right: 30),
                    alignment: Alignment.centerRight,
                    icon: FaIcon(FontAwesomeIcons.trash),
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          customHeader: FaIcon(
                            FontAwesomeIcons.ban,
                            color: backgroundColor,
                            size: 56,
                          ),
                          animType: AnimType.BOTTOMSLIDE,
                          title: '삭제',
                          desc: '선택된 아이템을 드레스룸에서 삭제하겠습니까?',
                          btnOkColor: greenColor,
                          btnCancelColor: pinkColor,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            Provider.of<DressRoomModel>(context, listen: false)
                                .removeItem();
                          })
                        ..show();
                    }
                    // final result = await showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //return DeleteAlertDialog();
                    // if (result == "remove") {
                    //   Provider.of<DressRoomModel>(context, listen: false)
                    //       .removeItem();
                    //   final snackBar = SnackBar(
                    //     duration: Duration(seconds: 1),
                    //     content: Text(
                    //       '아이템이 정상적으로 삭제 되었습니다.',
                    //     ),
                    // action: SnackBarAction(
                    //   textColor: Colors.yellow,
                    //   label: '확인',
                    //   onPressed: () {
                    //     // Some code to undo the change.
                    //   },
                    // ),
                    // );

                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                    // Scaffold.of(context).showSnackBar(snackBar);
                    // }
                    // },
                    ),
              ),
            ],
          )
        : Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  color: Colors.black26,
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerRight,
                  icon: FaIcon(FontAwesomeIcons.solidFolder),
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                    padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
                    color: Colors.black26,
                    onPressed: () {},
                    child: Text(
                      'MAKE',
                      style: whiteStyle,
                    )),
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
