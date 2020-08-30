import 'dart:io';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/lookbook/dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LookBookItem extends StatelessWidget {
  final Coordinate item;
  final int index;
  LookBookItem({this.item, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () {
              showDialog(context: context, child: LookBookDialog(item));
            },
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: item.top.thumbnail_url,
                      fit: BoxFit.cover,
                      httpHeaders: {
                        HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                      },
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: item.bottom.thumbnail_url,
                      fit: BoxFit.cover,
                      httpHeaders: {
                        HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                      },
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                UIHelper.horizontalSpaceSmall,
                Expanded(
                  flex: 3,
                  child: Text(
                    item.name,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 16,
                    color: Colors.black54,
                    icon: FaIcon(FontAwesomeIcons.edit),
                    onPressed: () {
                      final _textController = TextEditingController();
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
                          body: Column(children: <Widget>[
                            Text(
                              '수정',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration.collapsed(
                                    hintText: "새로운 이름을 입력해주세요"),
                              ),
                            ),
                          ]),
                          //),
                          desc: '선택된 아이템의 새로운 이름을 입력해주세요.',
                          btnOkColor: greenColor,
                          btnCancelColor: pinkColor,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            print(index);
                            Stride.analytics.logEvent(name: "LOOK_BOOK_RENAME");
                            Provider.of<LookBookModel>(context, listen: false)
                                .rename(index, _textController.text);
                          })
                        ..show();
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 16,
                    color: Colors.black54,
                    icon: FaIcon(FontAwesomeIcons.trash),
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          customHeader: FaIcon(
                            FontAwesomeIcons.ban,
                            color: backgroundColor,
                            size: 56,
                          ),
                          animType: AnimType.BOTTOMSLIDE,
                          title: '삭제',
                          desc: '선택된 아이템을 룩북에서 삭제하겠습니까?',
                          btnOkColor: greenColor,
                          btnCancelColor: pinkColor,
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            Stride.analytics.logEvent(name: "LOOK_BOOK_REMOVE");
                            Provider.of<LookBookModel>(context, listen: false)
                                .removeItem(item.id);
                          })
                        ..show();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
