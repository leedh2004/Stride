import 'dart:io';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/lookbook/lookbook_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../mapper.dart';
import 'folder_move_dialog.dart';
import 'item_rename_dialog.dart';

class LookBookItem extends StatefulWidget {
  final Coordinate item;
  final int index;
  final double opacity;
  final LookBookModel model;
  LookBookItem(this.item, this.index, this.opacity, this.model);

  @override
  _LookBookItemState createState() => _LookBookItemState();
}

class _LookBookItemState extends State<LookBookItem> {
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // showMaterialModalBottomSheet(
              //     backgroundColor: Colors.transparent,
              //     context: context,
              //     builder: (context, scrollController) {
              //       return LookBookDialog(widget.item);
              //     });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LookBookDialog(widget.item);
              }));
              Stride.logEvent(name: 'LOOKBOOK_ITEM_INFO_CLICKED');
            },
            child: Row(
              children: [
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.top.thumbnail_url,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                )),
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.bottom.thumbnail_url,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${widget.item.name}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(244, 244, 251, 1)),
                        child: Text(
                          '${typeConverter[widget.item.top.type]}',
                          style: TextStyle(fontSize: 10),
                        )),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(244, 244, 251, 1)),
                        child: Text(
                          '${typeConverter[widget.item.bottom.type]}',
                          style: TextStyle(fontSize: 10),
                        )),
                  ],
                )
              ],
            ),
            // InkWell(
            //   onTap: () {
            //     final _textController = TextEditingController();
            //     _textController.text = widget.item.name;
            //     AwesomeDialog(
            //         context: context,
            //         keyboardAware: true,
            //         dialogType: DialogType.ERROR,
            //         customHeader: FaIcon(
            //           FontAwesomeIcons.edit,
            //           color: backgroundColor,
            //           size: 56,
            //         ),
            //         animType: AnimType.BOTTOMSLIDE,
            //         btnOkText: '수정',
            //         btnCancelText: '취소',
            //         body: Column(children: <Widget>[
            //           Text(
            //             '수정',
            //             style: TextStyle(fontSize: 20),
            //           ),
            //           Padding(
            //             padding: EdgeInsets.only(left: 16),
            //             child: TextField(
            //               autofocus: true,
            //               inputFormatters: [
            //                 LengthLimitingTextInputFormatter(10),
            //               ],
            //               controller: _textController,
            //               decoration: InputDecoration.collapsed(
            //                   hintText: "새로운 이름을 입력해주세요"),
            //             ),
            //           ),
            //           UIHelper.verticalSpaceSmall,
            //           Text('룩북이 이름은 10글자 이하로 제한됩니다.')
            //         ]),
            //         //),
            //         desc: '선택된 아이템의 새로운 이름을 입력해주세요.',
            //         btnOkColor: backgroundColor,
            //         btnCancelColor: gray,
            //         btnCancelOnPress: () {},
            //         btnOkOnPress: () async {
            //           Stride.logEvent(name: "LOOKBOOK_RENAME");
            //           Provider.of<LookBookModel>(context, listen: false)
            //               .rename(widget.index, _textController.text);
            //         })
            //       ..show();
            //   },
            //   child: Image.asset(
            //     'assets/config.png',
            //     width: 20,
            //   ),
            // )
            CustomPopupMenu(
              arrowColor: Colors.white,
              child: Container(
                child: Image.asset('assets/config.png', width: 18),
                padding: EdgeInsets.fromLTRB(20, 20, 24, 20),
              ),
              menuBuilder: () => ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.white,
                  child: IntrinsicWidth(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _controller.hideMenu,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _controller.hideMenu();
                                    showMaterialModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context, scrollcontext) {
                                          return LookBookItemRenameDialog(
                                              widget.model, widget.item.id);
                                        });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _controller.hideMenu();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LookBookFolderMoveDialog(
                                          widget.model, widget.item.id);
                                    }));
                                    // showMaterialModalBottomSheet(
                                    //     shape:
                                    //         RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(
                                    //               10.0),
                                    //     ),
                                    //     backgroundColor:
                                    //         Colors.transparent,
                                    //     context: context,
                                    //     builder: (context,
                                    //         scrollcontext) {
                                    //       return LookBookFolderRenameDialog(
                                    //           lmodel);
                                    //     });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      '폴더 이동',
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    // Navigator.maybePop(context);
                                    _controller.hideMenu();
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
                                              "선택한 아이템을 삭제하시겠어요?",
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
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFF999999),
                                                              width: 1.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
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
                                                            color: Color(
                                                                0xFFED6D6D),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 1,
                                                                  offset:
                                                                      Offset(
                                                                          0, 3))
                                                            ]),
                                                        child: Center(
                                                          child: Text(
                                                            "삭제",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        widget.model.removeItem(
                                                            widget.item.id);
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
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      '삭제',
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
        )
      ],
    );
  }
}
