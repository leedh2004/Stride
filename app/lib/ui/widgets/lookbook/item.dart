import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/lookbook/dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LookBookItem extends StatelessWidget {
  final Coordinate item;
  final int index;
  LookBookItem({this.item, this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black45, width: 0.5)),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                showDialog(context: context, child: LookBookDialog(item));
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    height: 200,
                    child: Image.network(
                      item.top_thumbnail_url,
                      fit: BoxFit.cover,
                      headers: {
                        HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                      },
                    ),
                    // child: FancyShimmerImage(
                    //   imageUrl: item.top_thumbnail_url,
                    //   boxFit: BoxFit.cover,
                    //   errorWidget: Icon(Icons.error),
                    //   shimmerBaseColor: backgroundTransparentColor,
                    //   shimmerHighlightColor: backgroundColor,
                    //   shimmerBackColor: backgroundColor,
                    //   // placeholder: (context, url) => LoadingWidget(),
                    // )),
                  )),
                  Expanded(
                      child: Container(
                    height: 200,
                    child: Image.network(
                      item.bottom_thumbnail_url,
                      fit: BoxFit.cover,
                      headers: {
                        HttpHeaders.refererHeader: "http://api-stride.com:5000/"
                      },
                    ),
                    // child: FancyShimmerImage(
                    //   imageUrl: item.bottom_thumbnail_url,
                    //   boxFit: BoxFit.cover,
                    //   errorWidget: Icon(Icons.error),
                    //   shimmerBaseColor: backgroundTransparentColor,
                    //   shimmerHighlightColor: backgroundColor,
                    //   shimmerBackColor: backgroundColor,
                    //   // placeholder: (context, url) => LoadingWidget(),
                    // )),
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
                    flex: 2,
                    child: Text(
                      item.name,
                      style: subHeaderStyle,
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
                              Provider.of<LookBookModel>(context, listen: false)
                                  .removeItem(index);
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
      ),
    );
  }
}
