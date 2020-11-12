import 'dart:ui';

import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:app/ui/views/lookbook/view.dart';
import 'package:app/ui/widgets/dressroom/folder_create_dialog.dart';
import 'package:app/ui/widgets/lookbook/folder_create_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class CollectionView extends StatefulWidget {
  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView>
    with SingleTickerProviderStateMixin {
  var page = 0;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BaseWidget<DressRoomModel>(
          model: DressRoomModel(Provider.of(context, listen: false)),
          builder: (context, dmodel, child) {
            return BaseWidget<LookBookModel>(
                model: LookBookModel(Provider.of(context, listen: false)),
                builder: (context, lmodel, child) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: false,
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                        child: Text(
                          '드레스룸',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    floatingActionButton: Padding(
                      padding: EdgeInsets.all(16),
                      child: FloatingActionButton(
                        backgroundColor: Color.fromRGBO(128, 108, 231, 1),
                        onPressed: () {
                          if (controller.index == 0) {
                            Stride.logEvent(
                                name: "DRESSROOM_FODLER_BUTTON_CLICKED");
                            showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context, scrollcontext) {
                                  return FolderCreateDialog(dmodel);
                                });
                          } else {
                            Stride.logEvent(
                                name: "LOOKBOOK_FODLER_BUTTON_CLICKED");
                            showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context, scrollcontext) {
                                  return LookBookFolderCreateDialog(lmodel);
                                });
                          }
                        },
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                    body: Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: DefaultTabController(
                        length: 2,
                        child: NestedScrollView(
                          headerSliverBuilder: (context, value) {
                            return [
                              SliverAppBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(0),
                                  child: TabBar(
                                    controller: controller,
                                    labelColor:
                                        Color.fromRGBO(128, 108, 231, 1),
                                    unselectedLabelColor: Colors.black38,
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        width: 4,
                                        color: Color.fromRGBO(128, 108, 231, 1),
                                      ),
                                    ),
                                    tabs: [
                                      Tab(
                                        child: Text(
                                          '컬렉션',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          '룩북',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ];
                          },
                          body: TabBarView(
                            controller: controller,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: DressRoomFolderView(dmodel)),
                              Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: LookBookView(lmodel))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
      Provider.of<DressRoomService>(context).items[0].length < 5
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
                                '컬렉션에 아이템이 부족해요!',
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
                                      "아이템을 ",
                                    ),
                                    Text(
                                      "5개",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF8569EF)),
                                    ),
                                    Text("이상 저장하면")
                                  ]),
                              SizedBox(height: 4),
                              Text('기능을 사용하실 수 있습니다'),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/purple_star.png',
                                    width: 24,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "버튼을 눌러 마음에 드는 아이템을 저장해보세요!",
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ]),
              ),
            )
          : Container()
    ]);
  }
}

const currentStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
const notCurrentStyle =
    TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w700);
