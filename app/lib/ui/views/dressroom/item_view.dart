import 'dart:ui';

import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/widgets/dressroom/folder_move_dialog.dart';
import 'package:app/ui/widgets/dressroom/folder_rename_dialog.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/dressroom/select_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../base_widget.dart';

class DressRoomItemView extends StatefulWidget {
  @override
  _DressRoomItemViewState createState() => _DressRoomItemViewState();
}

class _DressRoomItemViewState extends State<DressRoomItemView> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String name;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DressRoomModel>(
        model: DressRoomModel(Provider.of(context)),
        builder: (context, dmodel, child) {
          var dservice = Provider.of<DressRoomService>(context, listen: false);
          name = dservice.folder[dservice.current_folder];
          if (name == "default") name = "내가 찜한 옷";
          List<RecentItem> items = dservice.items[dservice.current_folder];
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                '${name}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                dservice.current_folder == 0
                    ? Container()
                    : CustomPopupMenu(
                        arrowColor: Colors.white,
                        child: Container(
                          child: Image.asset('assets/more_menu.png', width: 18),
                          padding: EdgeInsets.fromLTRB(20, 20, 24, 20),
                        ),
                        menuBuilder: () => ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                            child: IntrinsicWidth(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: _controller.hideMenu,
                                    child: Container(
                                      height: 40,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _controller.hideMenu();
                                              showMaterialModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (context, scrollcontext) {
                                                    return FolderRenameDialog(
                                                        dmodel);
                                                  });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                '이름 변경',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: _controller.hideMenu,
                                    child: Container(
                                      height: 40,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () async {
                                              _controller.hideMenu();
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)),
                                                    title: Center(
                                                      child: Text(
                                                        "아이템을 삭제하시겠어요?",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                            child: Center(
                                                      child: Column(children: [
                                                        Text(
                                                          "※ 삭제 시 복구되지 않습니다.",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFF999999)),
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 106,
                                                                  height: 46,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Color(
                                                                            0xFF999999),
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "취소",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                              0xFF999999),
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 14,
                                                              ),
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 106,
                                                                  height: 46,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFFED6D6D),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors.grey.withOpacity(
                                                                                0.5),
                                                                            spreadRadius:
                                                                                1,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                Offset(0, 3))
                                                                      ]),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "삭제",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  dmodel.deleteFolder(
                                                                      dservice
                                                                          .current_folder);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ]),
                                                      ]),
                                                    )),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Text(
                                                '폴더 삭제',
                                                style: TextStyle(
                                                  color: Color(0xFFED6D6D),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ])),
                          ),
                        ),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        controller: _controller,
                      ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF4F4FC)),
                        child: Center(
                          child: Text(
                            '수집한 컬렉션으로 나만의 룩북을 만들 수 있습니다.',
                            style: TextStyle(color: Color(0xFF8569EF)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '총 ', style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: '${items.length}',
                            style: TextStyle(color: backgroundColor)),
                        TextSpan(
                            text: '개의 상품',
                            style: TextStyle(color: Colors.black)),
                      ])),
                      SizedBox(
                        height: 12,
                      ),
                      BaseWidget<RecentItemModel>(
                          model: RecentItemModel(
                              Provider.of(context), Provider.of(context)),
                          builder: (context, model, child) {
                            return Expanded(
                              child: Container(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.5,
                                      crossAxisSpacing: 15,
                                    ),
                                    itemCount: items.length,
                                    // padding: EdgeInsets.all(5),
                                    itemBuilder: (context, index) {
                                      double opacity = 0;
                                      RecentItem item = items[index];
                                      if (Provider.of<DressRoomModel>(context)
                                          .selectedIdx
                                          .contains(index)) {
                                        opacity = 1;
                                      }
                                      return DressRoomItemWidget(item, opacity,
                                          index, Provider.of(context));
                                    }),
                              ),
                            );
                            // });
                          }),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if (dmodel.selectedIdx.isEmpty) {
                                  ban_remove.show(context);
                                  return;
                                }
                                Stride.logEvent(
                                    name: "DRESSROOM_REMOVE_BUTTON_CLICKED");
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      title: Center(
                                        child: Text(
                                          "아이템을 삭제하시겠어요?",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                          child: Center(
                                        child: Column(children: [
                                          Text(
                                            "※ 삭제 시 복구되지 않습니다.",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF999999)),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    width: 106,
                                                    height: 46,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Color(0xFF999999),
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "취소",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF999999),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    width: 106,
                                                    height: 46,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFED6D6D),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 1,
                                                              offset:
                                                                  Offset(0, 3))
                                                        ]),
                                                    child: Center(
                                                      child: Text(
                                                        "삭제",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    print("delete");
                                                    dmodel.removeItem();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ]),
                                        ]),
                                      )),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xFFF4F4FC)),
                                child: Align(
                                  child: Image.asset('assets/delete.png',
                                      width: 22, height: 22),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Stride.logEvent(
                                    name: "DRESSROOM_FODLER_BUTTON_CLICKED");
                                if (dmodel.selectedIdx.isNotEmpty) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FolderMoveDialog(dmodel);
                                  }));
                                } else {
                                  ban_move.show(context);
                                }
                              },
                              child: Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xFFF4F4FC)),
                                child: Align(
                                  child: Image.asset('assets/folder_move.png',
                                      width: 22, height: 22),
                                ),
                              ),
                            ),
                            dmodel.top_cnt > 0 && dmodel.bottom_cnt > 0
                                ? InkWell(
                                    onTap: () {
                                      List<RecentItem> top =
                                          dmodel.findSelectedTop();
                                      List<RecentItem> bottom =
                                          dmodel.findSelectedBotoom();
                                      Stride.logEvent(
                                          name:
                                              "DRESSROOM_MAKE_BUTTON_CLICKED");
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return DressRoomSelectDialog(
                                            top, bottom);
                                      }));
                                      // Navigator.push(
                                      //     builder:
                                      //         (context, scrollController) =>
                                      //             DressRoomSelectDialog(
                                      //                 top, bottom));
                                    },
                                    child: Container(
                                      width: 202,
                                      height: 54,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xFF8569EF)),
                                      child: Center(
                                        child: Text(
                                          'MAKE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                : InkWell(
                                    onTap: () {
                                      ban_make.show(context);
                                    },
                                    child: Container(
                                      width: 202,
                                      height: 54,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xFFFAF9FC)),
                                      child: Center(
                                        child: Text(
                                          'MAKE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
