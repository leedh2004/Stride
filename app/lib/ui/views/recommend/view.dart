import 'package:app/core/viewmodels/views/recommend.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/recommend/item_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecommendationModel>(
        model: RecommendationModel(Provider.of(context), Provider.of(context)),
        builder: (context, model, child) {
          if (model.init == false) {
            model.initialize();
            return LoadingWidget();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이도현님이 평가한 아이템',
                      style: HeaderStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                '좋아요',
                                style: NormalStyle,
                              ),
                              Text(
                                '${model.authService.master.like}',
                                style: NumberStyle,
                              )
                            ],
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Container(
                          height: 25,
                          child: VerticalDivider(
                            color: Colors.black26,
                            width: 1,
                            thickness: 3,
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Container(
                          child: Column(
                            children: [
                              Text(
                                '콜렉션',
                                style: NormalStyle,
                              ),
                              Text(
                                '88',
                                style: NumberStyle,
                              )
                            ],
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Container(
                          height: 25,
                          child: VerticalDivider(
                            color: Colors.black26,
                            width: 1,
                            thickness: 3,
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Container(
                          child: Column(
                            children: [
                              Text(
                                '싫어요',
                                style: NormalStyle,
                              ),
                              Text(
                                '${model.authService.master.dislike}',
                                style: NumberStyle,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    ItemRow('추천 아이템', model.collectionService.recommendItems),
                    ItemRow('${model.collectionService.conceptA} 컨셉의 아이템',
                        model.collectionService.conceptItemA),
                    ItemRow('${model.collectionService.conceptB} 컨셉의 아이템',
                        model.collectionService.conceptItemB),
                    ItemRow('금주의 신상', model.collectionService.newArriveItems),
                  ],
                )
              ],
            ),
          );
        });
  }
}

const NumberStyle = TextStyle(
    color: backgroundColor, fontSize: 20, fontWeight: FontWeight.w700);
const NormalStyle = TextStyle(color: Colors.black54, fontSize: 16);
const HeaderStyle =
    TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700);
