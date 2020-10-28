import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:app/ui/views/lookbook/view.dart';
import 'package:app/ui/widgets/dressroom/folder_dialog.dart';
import 'package:app/ui/widgets/lookbook/LookBookFolderDialog.dart';
import 'package:flutter/material.dart';
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
    return BaseWidget<DressRoomModel>(
        model: DressRoomModel(Provider.of(context, listen: false)),
        builder: (context, model, child) {
          return BaseWidget<LookBookModel>(
              model: LookBookModel(Provider.of(context, listen: false)),
              builder: (context, lmodel, child) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    centerTitle: false,
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: Text(
                        '콜렉션',
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
                          Stride.analytics.logEvent(
                              name: "DRESSROOM_FODLER_BUTTON_CLICKED");
                          showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context, scrollcontext) {
                                return FolderDialog(model);
                              });
                        } else {
                          Stride.analytics
                              .logEvent(name: "LOOKBOOK_FODLER_BUTTON_CLICKED");
                          showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context, scrollcontext) {
                                return LookBookFolderDialog(lmodel);
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
                              backgroundColor: Colors.white,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(0),
                                child: TabBar(
                                  controller: controller,
                                  labelColor: Color.fromRGBO(128, 108, 231, 1),
                                  unselectedLabelColor: Colors.black38,
                                  indicatorColor:
                                      Color.fromRGBO(128, 108, 231, 1),
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        '콜렉션',
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
                                child: DressRoomFolderView()),
                            Padding(
                                padding: EdgeInsets.only(top: 24),
                                child: LookBookView())
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

const currentStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
const notCurrentStyle =
    TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w700);
