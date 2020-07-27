import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/models/coordinate.dart';
import 'package:frontend/core/viewmodels/widgets/look_book_model.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';
import 'package:frontend/ui/views/base_widget.dart';
import 'package:frontend/ui/views/login_view.dart';
import 'package:frontend/ui/widgets/look_book_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LookBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LookBookModel>(
      model: LookBookModel(api: Provider.of(context)),
      onModelReady: (model) {
        model.fetchItems();
      },
      builder: (context, model, child) {
        Widget showWidget;
        if (model.busy) {
          showWidget = LoadingWidget();
        } else {
          showWidget = Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                padding: EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  print("$index 전달");
                  return LookBookItem(item: model.items[index], index: index);
                },
                itemCount: model.items.length,
              ),
            ),
          );
        }
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: showWidget,
        );
      },
    );
  }
}

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
                        child: FancyShimmerImage(
                          imageUrl: item.top_thumbnail_url,
                          boxFit: BoxFit.cover,
                          errorWidget: Icon(Icons.error),
                          shimmerBaseColor: backgroundTransparentColor,
                          shimmerHighlightColor: backgroundColor,
                          shimmerBackColor: backgroundColor,
                          // placeholder: (context, url) => LoadingWidget(),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        height: 200,
                        child: FancyShimmerImage(
                          imageUrl: item.bottom_thumbnail_url,
                          boxFit: BoxFit.cover,
                          errorWidget: Icon(Icons.error),
                          shimmerBaseColor: backgroundTransparentColor,
                          shimmerHighlightColor: backgroundColor,
                          shimmerBackColor: backgroundColor,
                          // placeholder: (context, url) => LoadingWidget(),
                        )),
                  ),
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
                            btnOkOnPress: () {
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
