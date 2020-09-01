import 'package:app/core/models/product.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/widgets/dressroom/folder_dialog.dart';
import 'package:app/ui/widgets/dressroom/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DressRoomButtonBar extends StatelessWidget {
  final DressRoomModel model;
  DressRoomButtonBar(this.model);
  TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    // print(_textController.text);
    model.createFolder(_textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return model.selectedIdx.isNotEmpty
        ? Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  color: backgroundColor,
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerRight,
                  icon: FaIcon(FontAwesomeIcons.solidFolder),
                  onPressed: () {
                    var folder =
                        Provider.of<DressRoomService>(context, listen: false)
                            .folder;
                    var folderIds = folder.keys.toList();
                    var folderNames = folder.values.toList();
                    Stride.analytics
                        .logEvent(name: "DRESS_ROOM_FODLER_BUTTON_CLICKED");
                    showMaterialModalBottomSheet(
                        context: context,
                        builder: (context, scrollController) {
                          return FolderDialog(model);
                        });
                  },
                ),
              ),
              model.top_cnt > 0 && model.bottom_cnt > 0
                  ? MakeButton(model, context)
                  : DisableMakeButton(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    color: backgroundColor,
                    padding: EdgeInsets.only(right: 30),
                    alignment: Alignment.centerRight,
                    icon: FaIcon(FontAwesomeIcons.trash),
                    onPressed: () {
                      Stride.analytics
                          .logEvent(name: "DRESS_ROOM_REMOVE_BUTTON_CLICKED");
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
                            Stride.analytics
                                .logEvent(name: "DRESS_ROOM_REMOVE_ITEM");
                            Provider.of<DressRoomModel>(context, listen: false)
                                .removeItem();
                          })
                        ..show();
                    }),
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
              DisableMakeButton(),
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

Widget MakeButton(DressRoomModel model, BuildContext context) {
  return (Align(
    alignment: Alignment.center,
    child: FlatButton(
        padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
        color: backgroundColor,
        onPressed: () async {
          List<Product> top = model.findSelectedTop();
          List<Product> bottom = model.findSelectedBotoom();
          Stride.analytics.logEvent(name: "DRESS_ROOM_MAKE_BUTTON_CLICKED");
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
  ));
}

Widget DisableMakeButton() {
  return (Align(
    alignment: Alignment.center,
    child: FlatButton(
        padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
        color: Colors.black26,
        onPressed: () {},
        child: Text(
          'MAKE',
          style: whiteStyle,
        )),
  ));
}
