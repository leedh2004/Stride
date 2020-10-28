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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../mapper.dart';

class LookBookItem extends StatelessWidget {
  final Coordinate item;
  final int index;
  final double opacity;
  final RecentItemModel model;

  LookBookItem(this.item, this.index, this.opacity, this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              showMaterialModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context, scrollController) {
                    return LookBookDialog(item);
                  });
              Stride.analytics.logEvent(name: 'LOOKBOOK_ITEM_INFO_CLICKED');
            },
            child: Row(
              children: [
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: item.top.thumbnail_url,
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
                    imageUrl: item.bottom.thumbnail_url,
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
                  '${item.name}',
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
                          '${typeConverter[item.top.type]}',
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
                          '${typeConverter[item.bottom.type]}',
                          style: TextStyle(fontSize: 10),
                        )),
                  ],
                )
              ],
            ),
            InkWell(
              onTap: () {
                final _textController = TextEditingController();
                _textController.text = item.name;
                AwesomeDialog(
                    context: context,
                    keyboardAware: true,
                    dialogType: DialogType.ERROR,
                    customHeader: FaIcon(
                      FontAwesomeIcons.edit,
                      color: backgroundColor,
                      size: 56,
                    ),
                    animType: AnimType.BOTTOMSLIDE,
                    btnOkText: '수정',
                    btnCancelText: '취소',
                    body: Column(children: <Widget>[
                      Text(
                        '수정',
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: TextField(
                          autofocus: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          controller: _textController,
                          decoration: InputDecoration.collapsed(
                              hintText: "새로운 이름을 입력해주세요"),
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      Text('룩북이 이름은 10글자 이하로 제한됩니다.')
                    ]),
                    //),
                    desc: '선택된 아이템의 새로운 이름을 입력해주세요.',
                    btnOkColor: backgroundColor,
                    btnCancelColor: gray,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      print(index);
                      Stride.analytics.logEvent(name: "LOOKBOOK_RENAME");
                      Provider.of<LookBookModel>(context, listen: false)
                          .rename(index, _textController.text);
                    })
                  ..show();
              },
              child: Image.asset(
                'assets/config.png',
                width: 20,
              ),
            )
          ],
        )
      ],
    );
    // return Column(
    //   children: <Widget>[
    //     Stack(children: [
    //       Expanded(
    //                   child: Row(
    //           children: <Widget>[
    //             Expanded(
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.only(
    //                       bottomLeft: Radius.circular(8),
    //                       topLeft: Radius.circular(8)),
    //                   child: CachedNetworkImage(
    //                     imageUrl: item.top.compressed_thumbnail_url,
    //                     fit: BoxFit.cover,
    //                     httpHeaders: {
    //                       HttpHeaders.refererHeader: "http://api-stride.com:5000/"
    //                     },
    //                   ),
    //                 )),
    //             Expanded(
    //                 child: Container(
    //               height: 200,
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.only(
    //                     bottomRight: Radius.circular(8),
    //                     topRight: Radius.circular(8)),
    //                 child: CachedNetworkImage(
    //                   imageUrl: item.bottom.compressed_thumbnail_url,
    //                   fit: BoxFit.cover,
    //                   httpHeaders: {
    //                     HttpHeaders.refererHeader: "http://api-stride.com:5000/"
    //                   },
    //                 ),
    //               ),
    //             )),
    //           ],
    //         ),
    //       ),
    //       InkWell(
    //         onTap: () {
    //           Provider.of<LookBookModel>(context, listen: false)
    //               .selectItem(index);
    //         },
    //         child: Opacity(
    //           opacity: opacity,
    //           child: Container(
    //             height: 200,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.all(Radius.circular(8)),
    //               color: Color.fromRGBO(0, 0, 0, 0.4),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Opacity(
    //         opacity: opacity,
    //         child: Container(
    //           height: 200,
    //           child: Align(
    //             alignment: Alignment.bottomRight,
    //             child: Padding(
    //               padding: EdgeInsets.only(bottom: 10),
    //               child: IconButton(
    //                 iconSize: 25,
    //                 icon: FaIcon(
    //                   FontAwesomeIcons.search,
    //                   color: Colors.white,
    //                 ),
    //                 onPressed: () {
    //                   if (opacity == 1) {
    //                     Stride.analytics.logEvent(
    //                         name: 'LOOKBOOK_ITEM_INFO_CLICKED',
    //                         parameters: {
    //                           'itemId': item.id.toString(),
    //                         });
    //                     showMaterialModalBottomSheet(
    //                         backgroundColor: Colors.transparent,
    //                         context: context,
    //                         builder: (context, scrollController) {
    //                           return LookBookDialog(item);
    //                         });
    //                     Stride.analytics
    //                         .logEvent(name: 'LOOKBOOK_ITEM_INFO_CLICKED');
    //                   } else {
    //                     Provider.of<LookBookModel>(context, listen: false)
    //                         .selectItem(index);
    //                   }
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ]),
    //     Container(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           Text(
    //             item.name,
    //             style: TextStyle(fontSize: 16),
    //           ),
    //           InkWell(
    //             // padding: EdgeInsets.all(4),
    //             child: SvgPicture.asset(
    //               'images/edit.svg',
    //               width: 18,
    //               height: 23,
    //               color: Colors.black87,
    //             ),
    //             onTap: () {
    //               final _textController = TextEditingController();
    //               _textController.text = item.name;
    //               AwesomeDialog(
    //                   context: context,
    //                   keyboardAware: true,
    //                   dialogType: DialogType.ERROR,
    //                   customHeader: FaIcon(
    //                     FontAwesomeIcons.edit,
    //                     color: backgroundColor,
    //                     size: 56,
    //                   ),
    //                   animType: AnimType.BOTTOMSLIDE,
    //                   btnOkText: '수정',
    //                   btnCancelText: '취소',
    //                   body: Column(children: <Widget>[
    //                     Text(
    //                       '수정',
    //                       style: TextStyle(fontSize: 20),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 16),
    //                       child: TextField(
    //                         autofocus: true,
    //                         inputFormatters: [
    //                           LengthLimitingTextInputFormatter(10),
    //                         ],
    //                         controller: _textController,
    //                         decoration: InputDecoration.collapsed(
    //                             hintText: "새로운 이름을 입력해주세요"),
    //                       ),
    //                     ),
    //                     UIHelper.verticalSpaceSmall,
    //                     Text('룩북이 이름은 10글자 이하로 제한됩니다.')
    //                   ]),
    //                   //),
    //                   desc: '선택된 아이템의 새로운 이름을 입력해주세요.',
    //                   btnOkColor: backgroundColor,
    //                   btnCancelColor: gray,
    //                   btnCancelOnPress: () {},
    //                   btnOkOnPress: () async {
    //                     print(index);
    //                     Stride.analytics.logEvent(name: "LOOKBOOK_RENAME");
    //                     Provider.of<LookBookModel>(context, listen: false)
    //                         .rename(index, _textController.text);
    //                   })
    //                 ..show();
    //             },
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }
}
