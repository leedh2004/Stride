import 'dart:ui';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/widgets/dressroom/folder_dialog.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/lookbook/LookBookFolderDialog.dart';
import 'package:app/ui/widgets/lookbook/item.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../mapper.dart';
import '../base_widget.dart';
import '../product_web_view.dart';

class LookBookItemView extends StatefulWidget {
  String name;
  LookBookItemView(this.name);
  @override
  _LookBookItemViewState createState() => _LookBookItemViewState();
}

class _LookBookItemViewState extends State<LookBookItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '${widget.name}',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: BaseWidget<LookBookModel>(
                model: LookBookModel(Provider.of(context)),
                builder: (context, lmodel, child) {
                  var lservice =
                      Provider.of<LookBookService>(context, listen: false);
                  List<Coordinate> items =
                      lservice.items[lservice.current_folder];
                  return Column(
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
                            text: '개의 룩북',
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
                                      if (Provider.of<LookBookModel>(context)
                                          .selectedIdx
                                          .contains(index)) {
                                        opacity = 1;
                                      }
                                      return LookBookItem(
                                          item, index, opacity, model);
                                    }),
                              ),
                            );
                            // });
                          }),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       InkWell(
                      //         onTap: () {
                      //           Stride.analytics.logEvent(
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
                      //           Stride.analytics.logEvent(
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
                    ],
                  );
                }),
          ),
        ));
  }
}
