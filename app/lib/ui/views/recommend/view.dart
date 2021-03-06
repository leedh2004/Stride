import 'dart:ui';

import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/recommend.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/recommend/item_row.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';
import '../recent_item_view.dart';

class RecommendView extends StatefulWidget {
  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView> {
  int select = 0;
  ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController(initialScrollOffset: 0);
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh(RecommendationModel model) async {
      // monitor network fetch
      Stride.logEvent(name: "RECOMMEND_REFRESH_PAGE");
      await model.initialize();
      // await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    var authService =
        Provider.of<AuthenticationService>(context, listen: false);

    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              '?????????',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        body: BaseWidget<RecommendationModel>(
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
                      '???????????????',
                      model.collectionService.conceptA,
                      model.collectionService.conceptB
                    ];
                    return FadeIn(
                      delay: 0.5,
                      child: SmartRefresher(
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: () => _onRefresh(model),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(24, 0, 0, 8),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 24, 8),
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 12, 0, 12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Color(0xFFF4F4FC)),
                                      child: Center(
                                        child: Text(
                                          '????????? ?????? ?????????, ???????????? ??????????????????!',
                                          style: TextStyle(
                                              color: Color(0xFF8569EF)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '?????? ????????? ?????????',
                                          style: HeaderStyle,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Stride.logEvent(
                                                name:
                                                    "RECOMMEND_GO_TO_RECENT_SEE_ITEM_BUTTON_CLICKED");
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return RecentItemView();
                                            }));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 8, 24, 8),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 140,
                                          height: 102,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // color: Colors.red
                                              color: Color.fromRGBO(
                                                  245, 244, 247, 1)),
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
                                                    '?????????',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // color: Colors.red
                                              color: Color.fromRGBO(
                                                  245, 244, 247, 1)),
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
                                                    '????????????',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
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
                                  // '${name}??? ????????? ${model.collectionService.conceptA} ?????? ?????????',
                                  UIHelper.verticalSpaceLarge,

                                  select == 0
                                      ? Text(
                                          '???????????????\n????????? ?????????',
                                          style: headerStyle,
                                        )
                                      : Text(
                                          '???????????? ??????\n?????? ?????????',
                                          style: headerStyle,
                                        ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  select == 0
                                      ? Text(
                                          '????????????????????? ?????? ?????? ???????????? ???????????? ???????????????!',
                                          style: TextStyle(
                                              color: Color(0xff888C93)),
                                        )
                                      : Text(
                                          '????????? ????????? ?????? ???????????? ????????? ?????????????????????.',
                                          style: TextStyle(
                                              color: Color(0xff888C93)),
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
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                      color: Color(0xFF8569EF)),
                                                  child: Center(
                                                    child: Text(
                                                        '#${strList[index]}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        )),
                                                  ))
                                              : InkWell(
                                                  onTap: () {
                                                    Stride.logEvent(
                                                        name:
                                                            'RECOMMEND_CHANGE_CONCEPT_BUTTON_CLICKED');
                                                    _controller.animateTo(0,
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        curve: Curves.easeIn);
                                                    setState(() {
                                                      select = index;
                                                    });
                                                  },
                                                  child: Container(
                                                      width: 127,
                                                      height: 38,
                                                      margin: EdgeInsets.only(
                                                          right: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(19),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFF888C93))),
                                                      child: Center(
                                                        child: Text(
                                                            '#${strList[index]}',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF888C93),
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
                                          model
                                              .collectionService.recommendItems,
                                          recentmodel,
                                          _controller)
                                      : select == 1
                                          ? ItemRow(
                                              model.collectionService
                                                  .conceptItemA,
                                              recentmodel,
                                              _controller)
                                          : ItemRow(
                                              model.collectionService
                                                  .conceptItemB,
                                              recentmodel,
                                              _controller),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    '????????? ??????',
                                    style: headerStyle,
                                  ),
                                  SizedBox(height: 16),
                                  ItemRow(
                                      model.collectionService.newArriveItems,
                                      recentmodel,
                                      _controller),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
      authService.master.like < 5
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white70,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/like_lock.png',
                        width: 150,
                      ),
                      // FaIcon(FontAwesomeIcons.lock, color: Colors.amber),
                      SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '?????? ???????????? ????????????!',
                                style: TextStyle(
                                    color: Color(
                                      0xFF2B3341,
                                    ),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "???????????? ",
                                    ),
                                    Text(
                                      "5???",
                                      style: TextStyle(
                                          color: Color(0xFF8569EF),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text("????????????")
                                  ]),
                              SizedBox(height: 4),
                              Text('????????? ???????????? ??? ????????????')
                            ]),
                      ),
                    ]),
              ),
            )
          : Container()
    ]);
  }
}

const LikeNumberStyle =
    TextStyle(color: pinkColor, fontSize: 20, fontWeight: FontWeight.w700);
const DislikeNumberStyle =
    TextStyle(color: blueColor, fontSize: 20, fontWeight: FontWeight.w700);
const NormalStyle = TextStyle(color: Colors.black54, fontSize: 16);
const HeaderStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
