import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/input_dialog.dart';
import 'package:app/ui/widgets/tutorial/tutorial_card.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';

class TutorialView extends StatefulWidget {
  @override
  _TutorialViewState createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  bool enabled = true;
  bool size = false;
  int cnt = 0;

  callback() {
    setState(() {
      cnt++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Text pass;
    Text upText;
    Text downText;
    Image image;
    if (cnt == 0) {
      upText = Text('10개 이상의 아이템을 평가해주세요 :)', style: TutorialSubHeaderStyle);
      downText = Text(
        '아이템을 좌/우/위로 스와이프해 평가해봐요!',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '건너 뛰기',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/swipe.png');
    } else if (cnt < 4) {
      upText = Text('조금씩 취향을 알아가는 중이에요.', style: TutorialSubHeaderStyle);
      downText = Text(
        '애매한 아이템은 위로 스와이프해요.',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '건너 뛰기',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/swipe.png');
    } else if (cnt < 7) {
      upText = Text('스와이프 하는 게 나름 재미있지 않으세요?', style: TutorialSubHeaderStyle);
      downText = Text(
        '좌/우 를 탭하면 같은 옷을 더 볼 수 있어요',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '건너 뛰기',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/tap.png');
    } else if (cnt < 11) {
      upText =
          Text('좋아요. 이제 조금씩 취향의 윤곽이 드러납니다.', style: TutorialSubHeaderStyle);
      downText = Text(
        '줄 자 버튼을 탭하면 상품의 사이즈를 알 수 있어요.',
        style: TutorialSubHeaderStyle,
      );
      if (cnt == 10) {
        pass = Text(
          '완료',
          style: TutorialSubHeaderStyle,
        );
      } else {
        pass = Text(
          '건너 뛰기',
          style: TutorialSubHeaderStyle,
        );
      }
      image = Image.asset('images/ruler.png');
    } else if (cnt < 14) {
      upText = Text('더 하시기로 마음 먹었군요!', style: TutorialSubHeaderStyle);
      downText = Text(
        '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '완료',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/ruler.png');
    } else if (cnt < 20) {
      upText = Text(
        '어떤 작품을 좋아하실지 조금씩 감이 와요.',
        style: TutorialSubHeaderStyle,
      );
      downText = Text(
        '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '완료',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/ruler.png');
    } else {
      upText = Text(
        '아하, 이런 스타일이시군요!',
        style: TutorialSubHeaderStyle,
      );
      downText = Text(
        '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
        style: TutorialSubHeaderStyle,
      );
      pass = Text(
        '완료',
        style: TutorialSubHeaderStyle,
      );
      image = Image.asset('images/ruler.png');
    }

    return Scaffold(
        body: BaseWidget<SwipeModel>(
            model: SwipeModel(
              Provider.of<DressRoomService>(context),
              Provider.of<SwipeService>(context),
            ),
            builder: (context, model, child) {
              if (model.trick)
                return FadeIn(delay: 1, child: (LoadingWidget()));
              if (Provider.of<SwipeService>(context).init == false) {
                model.initCards();
                if (Provider.of<DressRoomService>(context).init == false) {
                  Provider.of<DressRoomService>(context).getDressRoom();
                }
                return LoadingWidget();
              }
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (!size) {
                  showMaterialModalBottomSheet(
                      isDismissible: true,
                      expand: false,
                      context: context,
                      builder: (context, scrollController) =>
                          InputInfoDialog());
                  size = true;
                }
              });
              return FadeIn(
                delay: 0.3,
                child: Stack(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: upperTextBar(context, upText, pass, cnt),
                  ),
                  // upperTextBar(context, upText, pass, cnt),
                  // verticalDirection: VerticalDirection.down,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          UIHelper.verticalSpaceMedium,
                          downText,
                          UIHelper.verticalSpaceMedium,
                          Container(width: 50, height: 50, child: image),
                          TutorialSwipeCardSection(context, model, callback),
                        ],
                      ))
                ]),
              );
            }));
  }

  Widget upperTextBar(BuildContext context, Text upText, Text pass, int cnt) {
    return Container(
        height: 160,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(children: [
          UIHelper.verticalSpaceMedium,
          UIHelper.verticalSpaceMedium,
          Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Text(
                  '$cnt',
                  style: TutorialheaderStyle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Provider.of<AuthenticationService>(context, listen: false)
                      .tutorialPass();
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0), child: pass),
              ),
            )
          ]),
          UIHelper.verticalSpaceSmall,
          upText,
        ]));
  }
}
