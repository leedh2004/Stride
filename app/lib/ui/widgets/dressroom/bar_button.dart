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
import 'package:flutter_svg/svg.dart';
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
    if (model.selectedIdx.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: ButtonTheme(
                      minWidth: 46,
                      height: 46,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        color: Color.fromRGBO(245, 242, 253, 1),
                        child: SvgPicture.asset('images/folder.svg',
                            width: 25, height: 25),
                        onPressed: () {
                          Stride.analytics.logEvent(
                              name: "DRESS_ROOM_FODLER_BUTTON_CLICKED");
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return FolderDialog(model);
                              });
                        },
                      ),
                    ))),
            model.top_cnt > 0 && model.bottom_cnt > 0
                ? MakeButton(model, context)
                : DisableMakeButton(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 30),
                child: ButtonTheme(
                  minWidth: 46,
                  height: 46,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      color: Color.fromRGBO(227, 220, 242, 1),
                      padding: EdgeInsets.all(0),
                      child: SvgPicture.asset('images/trash.svg',
                          width: 25, height: 25, semanticsLabel: 'Acme Logo'),
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
                              Provider.of<DressRoomModel>(context,
                                      listen: false)
                                  .removeItem();
                            })
                          ..show();
                      }),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 30),
                child: ButtonTheme(
                  minWidth: 46,
                  height: 46,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    color: Color.fromRGBO(245, 242, 253, 1),
                    child: SvgPicture.asset('images/folder.svg',
                        width: 25, height: 25),
                    // alignment: Alignment.centerRight,

                    // icon: FaIcon(FontAwesomeIcons.solidFolder),
                    onPressed: () {
                      // var folder =
                      //     Provider.of<DressRoomService>(context, listen: false)
                      //         .folder;
                      // var folderIds = folder.keys.toList();
                      // var folderNames = folder.values.toList();
                      Stride.analytics
                          .logEvent(name: "DRESS_ROOM_FODLER_BUTTON_CLICKED");
                      showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context, scrollController) {
                            return FolderDialog(model);
                          });
                    },
                  ),
                ),
              ),
            ),
            DisableMakeButton(),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: ButtonTheme(
                        minWidth: 46,
                        height: 46,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23),
                            ),
                            color: Color.fromRGBO(242, 242, 242, 1),
                            padding: EdgeInsets.all(0),
                            child: SvgPicture.asset('images/trash.svg',
                                width: 25, height: 25),
                            onPressed: () {}))))
          ],
        ),
      );
    }
  }
}

Widget MakeButton(DressRoomModel model, BuildContext context) {
  return (Align(
    alignment: Alignment.center,
    child: FlatButton(
        padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
        color: backgroundColor,
        onPressed: () async {
          List<Product> top = model.findSelectedTop();
          List<Product> bottom = model.findSelectedBotoom();
          Stride.analytics.logEvent(name: "DRESS_ROOM_MAKE_BUTTON_CLICKED");
          showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
        color: Colors.black26,
        onPressed: () {},
        child: Text(
          'MAKE',
          style: whiteStyle,
        )),
  ));
}
