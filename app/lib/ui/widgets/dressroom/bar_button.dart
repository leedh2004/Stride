import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/dressroom/folder_dialog.dart';
import 'package:app/ui/widgets/dressroom/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DressRoomButtonBar extends StatefulWidget {
  final DressRoomModel model;
  DressRoomButtonBar(this.model);
  @override
  _DressRoomButtonBarState createState() => _DressRoomButtonBarState();
}

class _DressRoomButtonBarState extends State<DressRoomButtonBar> {
  TextEditingController _textController = TextEditingController();
  GlobalKey folderButton = GlobalKey();
  GlobalKey makeButton = GlobalKey();
  GlobalKey trashButton = GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  @override
  void initState() {
    initTargets();
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
                                return FolderDialog(widget.model);
                              });
                        },
                      ),
                    ))),
            widget.model.top_cnt > 0 && widget.model.bottom_cnt > 0
                ? MakeButton(widget.model, context)
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Provider.of<AuthenticationService>(context, listen: false)
                .dress_tutorial ==
            false) {
          Provider.of<AuthenticationService>(context, listen: false)
              .dress_tutorial = true;
          var _storage =
              Provider.of<AuthenticationService>(context, listen: false)
                  .storage;
          _storage.write(key: 'dress_tutorial', value: 'true');
          _afterLayout(_);
        }
      });
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
                  key: folderButton,
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
                            return FolderDialog(widget.model);
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
                        key: trashButton,
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

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: folderButton,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "폴더 버튼",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "폴더로 나만의 옷들을 편하게 관리할 수 있습니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: makeButton,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "MAKE BUTTON",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상/하의를 클릭하면 활성화됩니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "상/하의를 조합하여 나만의 룩북을 만들 수 있습니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    UIHelper.verticalSpaceLarge,
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ))
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: trashButton,
        color: backgroundColor,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "휴지통",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "선택된 옷들을 모두 삭제합니다.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        hideSkip: true,
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 500), () {
      showTutorial();
    });
  }

  Widget DisableMakeButton() {
    return (Align(
      alignment: Alignment.center,
      child: FlatButton(
          key: makeButton,
          padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
          color: Colors.black26,
          onPressed: () {},
          child: Text(
            'MAKE',
            style: whiteStyle,
          )),
    ));
  }

  Widget MakeButton(DressRoomModel model, BuildContext context) {
    return (Align(
      alignment: Alignment.center,
      child: FlatButton(
          padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
          color: backgroundColor,
          onPressed: () async {
            List<RecentItem> top = model.findSelectedTop();
            List<RecentItem> bottom = model.findSelectedBotoom();
            Stride.analytics.logEvent(name: "DRESSROOM_MAKE_BUTTON_CLICKED");
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
}

// class DressRoomButtonBar extends StatelessWidget {
//   final DressRoomModel model;
//   DressRoomButtonBar(this.model);
//   TextEditingController _textController = TextEditingController();

// }
