import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/dressroom/folder_dialog.dart';
import 'package:app/ui/widgets/dressroom/select_dialog.dart';
import 'package:app/ui/widgets/lookbook/LookBookFolderDialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LookBookButtonBar extends StatefulWidget {
  final LookBookModel model;
  LookBookButtonBar(this.model);
  @override
  _LookBookButtonBarState createState() => _LookBookButtonBarState();
}

class _LookBookButtonBarState extends State<LookBookButtonBar> {
  TextEditingController _textController = TextEditingController();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispopse() {
    super.dispose();
  }

  void _handleSubmitted(String text) {
    // print(_textController.text);
    widget.model.createFolder(_textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.selectedIdx.isNotEmpty) {
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
                              name: "DRESSROOM_FODLER_BUTTON_CLICKED");
                          showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context, scrollcontext) {
                                return LookBookFolderDialog(widget.model);
                              });
                        },
                      ),
                    ))),
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
                            .logEvent(name: "DRESSROOM_REMOVE_BUTTON_CLICKED");
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
                            btnOkText: '삭제',
                            btnOkColor: backgroundColor,
                            btnCancelText: '취소',
                            btnCancelColor: gray,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              Provider.of<LookBookModel>(context, listen: false)
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
                    onPressed: () {
                      Stride.analytics
                          .logEvent(name: "DRESSROOM_FODLER_BUTTON_CLICKED");
                      showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context, scrollController) {
                            return LookBookFolderDialog(widget.model);
                          });
                    },
                  ),
                ),
              ),
            ),
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

// class LookBookButtonBar extends StatelessWidget {
//   final DressRoomModel model;
//   LookBookButtonBar(this.model);
//   TextEditingController _textController = TextEditingController();

// }
