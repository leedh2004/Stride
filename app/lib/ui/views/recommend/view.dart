import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/recommend.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/recommend/item_row.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecommendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecommendationModel>(
        model: RecommendationModel(Provider.of(context, listen: false),
            Provider.of(context, listen: false)),
        builder: (context, model, child) {
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
                return FadeIn(
                  delay: 0.5,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UIHelper.verticalSpaceSmall,
                            Text(
                              '${model.authService.master.name}님이 평가한 아이템',
                              style: HeaderStyle,
                            ),
                            UIHelper.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: pinkColor,
                                        size: 50,
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                        '${model.authService.master.like}',
                                        style: LikeNumberStyle,
                                      )
                                    ],
                                  ),
                                ),
                                UIHelper.horizontalSpaceSmall,
                                // Container(
                                //   height: 25,
                                //   child: VerticalDivider(
                                //     color: Colors.black26,
                                //     width: 1,
                                //     thickness: 3,
                                //   ),
                                // ),
                                UIHelper.horizontalSpaceSmall,
                                Container(
                                  child: Column(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.times,
                                        color: blueColor,
                                        size: 55,
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                        '${model.authService.master.dislike}',
                                        style: DislikeNumberStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            UIHelper.verticalSpaceSmall,
                            ItemRow(
                                '추천 아이템',
                                model.collectionService.recommendItems,
                                recentmodel),
                            ItemRow(
                                '${model.collectionService.conceptA} 컨셉의 아이템',
                                model.collectionService.conceptItemA,
                                recentmodel),
                            ItemRow(
                                '${model.collectionService.conceptB} 컨셉의 아이템',
                                model.collectionService.conceptItemB,
                                recentmodel),
                            ItemRow(
                                '금주의 신상',
                                model.collectionService.newArriveItems,
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
