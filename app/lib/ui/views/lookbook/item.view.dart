import 'dart:ui';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/lookbook/folder_rename_dialog.dart';
import 'package:app/ui/widgets/lookbook/item.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';

class LookBookItemView extends StatefulWidget {
  @override
  _LookBookItemViewState createState() => _LookBookItemViewState();
}

class _LookBookItemViewState extends State<LookBookItemView> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String name;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LookBookModel>(
        model: LookBookModel(Provider.of(context)),
        builder: (context, lmodel, child) {
          var lservice = Provider.of<LookBookService>(context, listen: false);
          name = lservice.folder[lservice.current_folder];
          if (name == "default") name = "나의 룩북";
          List<Coordinate> items = lservice.items[lservice.current_folder];
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
                  lservice.current_folder == 0
                      ? Container()
                      : CustomPopupMenu(
                          arrowColor: Colors.white,
                          child: Container(
                            child:
                                Image.asset('assets/more_menu.png', width: 18),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                _controller.hideMenu();
                                                showMaterialModalBottomSheet(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (context,
                                                        scrollcontext) {
                                                      return LookBookFolderRenameDialog(
                                                          lmodel);
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
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
                                                        child: Column(
                                                            children: [
                                                              Text(
                                                                "※ 삭제 시 복구되지 않습니다.",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
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
                                                                        width:
                                                                            106,
                                                                        height:
                                                                            46,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Color(0xFF999999),
                                                                              width: 1.0),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "취소",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xFF999999),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
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
                                                                        width:
                                                                            106,
                                                                        height:
                                                                            46,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Color(0xFFED6D6D),
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            boxShadow: [
                                                                              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 1, offset: Offset(0, 3))
                                                                            ]),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "삭제",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        lmodel.deleteFolder(
                                                                            lservice.current_folder);
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
                              text: '총 ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: '${items.length}',
                              style: TextStyle(color: backgroundColor)),
                          TextSpan(
                              text: '개의 룩북',
                              style: TextStyle(color: Colors.black)),
                        ])),
                        SizedBox(
                          height: 12,
                        ),
                        items.length > 0
                            ? BaseWidget<RecentItemModel>(
                                model: RecentItemModel(
                                    Provider.of(context), Provider.of(context)),
                                builder: (context, model, child) {
                                  return Expanded(
                                    child: Container(
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 4 / 3,
                                            crossAxisSpacing: 15,
                                          ),
                                          itemCount: items.length,
                                          // padding: EdgeInsets.all(5),
                                          itemBuilder: (context, index) {
                                            double opacity = 0;
                                            Coordinate item = items[index];
                                            if (Provider.of<LookBookModel>(
                                                    context)
                                                .selectedIdx
                                                .contains(index)) {
                                              opacity = 1;
                                            }
                                            return LookBookItem(
                                                item, index, opacity, lmodel);
                                          }),
                                    ),
                                  );
                                  // });
                                })
                            : Container()
                      ],
                    )),
              ));
        });
  }
}

// Padding(
//   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       InkWell(
//         onTap: () {
//           Stride.logEvent(
//               name: "LOOKBOOK_REMOVE_BUTTON_CLICKED");
//           AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               customHeader: FaIcon(
//                 FontAwesomeIcons.ban,
//                 color: backgroundColor,
//                 size: 56,
//               ),
//               animType: AnimType.BOTTOMSLIDE,
//               title: '삭제',
//               desc: '선택된 아이템을 룩북에서 삭제하겠습니까?',
//               btnOkText: '삭제',
//               btnOkColor: backgroundColor,
//               btnCancelText: '취소',
//               btnCancelColor: gray,
//               btnCancelOnPress: () {},
//               btnOkOnPress: () {
//                 Provider.of<LookBookModel>(context,
//                         listen: false)
//                     .removeItem();
//               })
//             ..show();
//         },
//         child: Container(
//           width: 54,
//           height: 54,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Color(0xFFF4F4FC)),
//           child: Align(
//             child: SvgPicture.asset('images/trash.svg',
//                 width: 22, height: 22),
//           ),
//         ),
//       ),
//       InkWell(
//         onTap: () {
//           Stride.logEvent(
//               name: "DRESSROOM_FODLER_BUTTON_CLICKED");
//           showMaterialModalBottomSheet(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               backgroundColor: Colors.transparent,
//               context: context,
//               builder: (context, scrollcontext) {
//                 return LookBookFolderDialog(lmodel);
//               });
//         },
//         child: Container(
//           width: 54,
//           height: 54,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Color(0xFFF4F4FC)),
//           child: Align(
//             child: SvgPicture.asset('images/folder.svg',
//                 width: 22, height: 22),
//           ),
//         ),
//       ),
//     ],
//   ),
// )
