import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/recommend.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/recommend/item_row.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recent_item_view.dart';

String NumToStr(int num) {}

class RecommendView extends StatefulWidget {
  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView> {
  int select = 0;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecommendationModel>(
        model: RecommendationModel(Provider.of(context, listen: false),
            Provider.of(context, listen: false)),
        builder: (context, model, child) {
          String name = model.authService.master.name;
          if (model.busy) {
            return LoadingWidget();
          }
          if (model.init == false) {
            model.initialize();
            return LoadingWidget();
          }
          return BaseWidget<RecentItemModel>(
              model: RecentItemModel(Provider.of(context, listen: false),
                  Provider.of(context, listen: false)),
              builder: (context, recentmodel, child) {
                List<dynamic> strList = [
                  '추천아이템',
                  model.collectionService.conceptA,
                  model.collectionService.conceptB
                ];

                return FadeIn(
                  delay: 0.5,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 0, 0, 8),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '최근 평가한 아이템',
                                    style: HeaderStyle,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RecentItemView();
                                      }));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 8, 24, 8),
                                      child: Image.asset(
                                        'assets/right-arrow.png',
                                        width: 10,
                                      ),
                                    ),
                                  )
                                ]),
                            UIHelper.verticalSpaceMedium,
                            Padding(
                              padding: EdgeInsets.only(right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 102,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        // color: Colors.red
                                        color:
                                            Color.fromRGBO(245, 244, 247, 1)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/like-of-filled-heart.png',
                                              width: 18,
                                            ),
                                            UIHelper.horizontalSpaceSmall,
                                            Text(
                                              '좋아요',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceSmall,
                                        Text(
                                          '${priceText(model.authService.master.like)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 33),
                                        )
                                      ],
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,
                                  UIHelper.horizontalSpaceSmall,
                                  Container(
                                    width: 140,
                                    height: 102,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        // color: Colors.red
                                        color:
                                            Color.fromRGBO(245, 244, 247, 1)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/close_purple.png',
                                              width: 18,
                                            ),
                                            UIHelper.horizontalSpaceSmall,
                                            Text(
                                              '별로에요',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                        UIHelper.verticalSpaceSmall,
                                        Text(
                                          '${priceText(model.authService.master.dislike)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 33),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // '${name}님 취향의 ${model.collectionService.conceptA} 컨셉 아이템',
                            UIHelper.verticalSpaceLarge,
                            Text(
                              '회원님을 위한\n추천 아이템',
                              style: headerStyle,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              '회원님 취향에 맞는 아이템을 분석해 추천해드립니다.',
                              style: TextStyle(color: Color(0xff888C93)),
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            SizedBox(
                              height: 38,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(3, (index) {
                                    return select == index
                                        ? Container(
                                            width: 127,
                                            height: 38,
                                            margin: EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                                color: Color(0xFF8569EF)),
                                            child: Center(
                                              child: Text('#${strList[index]}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            ))
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                select = index;
                                              });
                                            },
                                            child: Container(
                                                width: 127,
                                                height: 38,
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            19),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFF888C93))),
                                                child: Center(
                                                  child: Text(
                                                      '#${strList[index]}',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF888C93),
                                                      )),
                                                )),
                                          );
                                  })),
                            ),

                            SizedBox(
                              height: 16,
                            ),
                            select == 0
                                ? ItemRow(
                                    model.collectionService.recommendItems,
                                    recentmodel)
                                : select == 1
                                    ? ItemRow(
                                        model.collectionService.conceptItemA,
                                        recentmodel)
                                    : ItemRow(
                                        model.collectionService.conceptItemB,
                                        recentmodel),

                            Text(
                              '금주의 신상',
                              style: headerStyle,
                            ),
                            SizedBox(height: 16),
                            ItemRow(model.collectionService.newArriveItems,
                                recentmodel),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

const LikeNumberStyle =
    TextStyle(color: pinkColor, fontSize: 20, fontWeight: FontWeight.w700);
const DislikeNumberStyle =
    TextStyle(color: blueColor, fontSize: 20, fontWeight: FontWeight.w700);
const NormalStyle = TextStyle(color: Colors.black54, fontSize: 16);
const HeaderStyle =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700);
