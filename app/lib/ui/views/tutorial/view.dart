import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/tutorial.dart';
import 'package:app/core/viewmodels/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/swipe/input_dialog.dart';
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

  // callback() {
  //   setState(() {
  //     cnt++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Text upText, downText;
    Image image;
    if (cnt == 0) {
      upText = Text('취향의 옷을 10개 이상 선택해주세요 :)', style: TutorialSubHeaderStyle);
      // downText = Text(
      //   '아이템을 좌/우/위로 스와이프해 평가해봐요!',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '건너 뛰기',
      //   style: TutorialSubHeaderStyle,
      // );
      image = Image.asset('images/swipe.png');
    } else if (cnt < 4) {
      upText = Text('조금씩 취향을 알아가는 중이에요.', style: TutorialSubHeaderStyle);
      // downText = Text(
      //   '애매한 아이템은 위로 스와이프해요.',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '건너 뛰기',
      //   style: TutorialSubHeaderStyle,
      // );
      image = Image.asset('images/swipe.png');
    } else if (cnt < 7) {
      upText = Text(
        '어떤 옷을 좋아하실지 조금씩 감이 와요.',
        style: TutorialSubHeaderStyle,
      );
      // downText = Text(
      //   '좌/우 를 탭하면 같은 옷을 더 볼 수 있어요',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '건너 뛰기',
      //   style: TutorialSubHeaderStyle,
      // );
      image = Image.asset('images/tap.png');
    } else if (cnt < 19) {
      upText = Text(
        '아하, 이런 스타일이시군요!',
        style: TutorialSubHeaderStyle,
      );
      // downText = Text(
      //   '줄 자 버튼을 탭하면 상품의 사이즈를 알 수 있어요.',
      //   style: TutorialSubHeaderStyle,
      // );
      if (cnt == 10) {
        // pass = Text(
        //   '완료',
        //   style: TutorialSubHeaderStyle,
        // );
      } else {
        // pass = Text(
        //   '건너 뛰기',
        //   style: TutorialSubHeaderStyle,
        // );
      }
      image = Image.asset('images/ruler.png');
      // } else if (cnt < 14) {
      //   upText = Text('더 하시기로 마음 먹었군요!', style: TutorialSubHeaderStyle);
      // downText = Text(
      //   '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '완료',
      //   style: TutorialSubHeaderStyle,
      // );
      //   image = Image.asset('images/ruler.png');
      // } else if (cnt < 20) {
      //   upText = Text(
      //     '어떤 옷을 좋아하실지 조금씩 감이 와요.',
      //     style: TutorialSubHeaderStyle,
      //   );
      // downText = Text(
      //   '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '완료',
      //   style: TutorialSubHeaderStyle,
      // );
      //   image = Image.asset('images/ruler.png');
      // } else {
      //   upText = Text(
      //     '아하, 이런 스타일이시군요!',
      //     style: TutorialSubHeaderStyle,
      //   );
      // downText = Text(
      //   '사이즈에 맞는 옷만 추천해드릴 수 있어요!',
      //   style: TutorialSubHeaderStyle,
      // );
      // pass = Text(
      //   '완료',
      //   style: TutorialSubHeaderStyle,
      // );
      // image = Image.asset('images/ruler.png');
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!size) {
        showMaterialModalBottomSheet(
            isDismissible: false,
            expand: false,
            enableDrag: false,
            context: context,
            builder: (context, scrollController) => InputInfoDialog());
        size = true;
      }
    });

    TutorialService service =
        Provider.of<TutorialService>(context, listen: false);

    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      upperTextBar(context, upText, cnt),
      UIHelper.verticalSpaceSmall,
      BaseWidget<TutorialModel>(
          model: TutorialModel(
            service,
          ),
          builder: (context, model, child) {
            if (service.init == false) {
              model.getItem();
              return Container(child: LoadingWidget());
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 3,
                    ),
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      int product_id = model.service.items[index].product_id;
                      String thumbnail = model.service.items[index].thumbnail;
                      return model.selected.contains(product_id)
                          ? InkWell(
                              onTap: () {
                                model.removeItem(product_id);
                                setState(() {
                                  cnt--;
                                });
                              },
                              child: Stack(children: [
                                Positioned.fill(
                                  child: Image.network(
                                    thumbnail,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]),
                            )
                          : InkWell(
                              onTap: () {
                                model.addItem(product_id);
                                setState(() {
                                  cnt++;
                                });
                              },
                              child: Image.network(
                                thumbnail,
                                fit: BoxFit.cover,
                              ),
                            );
                    },
                    itemCount: model.service.items.length,
                  ),
                  UIHelper.verticalSpaceMedium,
                  cnt >= 10
                      ? RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
                          color: backgroundColor,
                          onPressed: () async {
                            await model.sendItems();
                            Provider.of<AuthenticationService>(context,
                                    listen: false)
                                .tutorialPass();
                          },
                          child: Container(
                            child: Text(
                              '완료',
                              style: whiteStyle,
                            ),
                          ))
                      : RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
                          color: backgroundColor,
                          onPressed: () {
                            model.getItem();
                          },
                          child: Container(
                            child: Text(
                              '다음',
                              style: whiteStyle,
                            ),
                          ))

                  // downText,
                ]);
          }),
    ]));
  }

  Widget upperTextBar(BuildContext context, Text upText, int cnt) {
    return Container(
        child: Column(children: [
      UIHelper.verticalSpaceMedium,
      UIHelper.verticalSpaceMedium,
      Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            child: Text(
              '$cnt / 10',
              style: TutorialheaderStyle,
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: InkWell(
        //     onTap: () {
        //       Provider.of<AuthenticationService>(context, listen: false)
        //           .tutorialPass();
        //     },
        //     child:
        //         Padding(padding: EdgeInsets.fromLTRB(0, 5, 10, 0), child: pass),
        //   ),
        // )
      ]),
      UIHelper.verticalSpaceSmall,
      upText,
    ]));
  }
}
