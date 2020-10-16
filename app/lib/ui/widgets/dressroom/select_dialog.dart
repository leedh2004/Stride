import 'dart:io';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DressRoomSelectDialog extends StatefulWidget {
  final List<RecentItem> top;
  final List<RecentItem> bottom;
  final CarouselController _controller = CarouselController();
  DressRoomSelectDialog(this.top, this.bottom);
  @override
  _DressRoomSelectDialogState createState() => _DressRoomSelectDialogState();
}

class _DressRoomSelectDialogState extends State<DressRoomSelectDialog> {
  String page = "default";
  TextEditingController _renameTextController = TextEditingController();
  int top_idx = 0;
  int bottom_idx = 0;

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    if (page == "default") {
      showWidget = SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CarouselSlider.builder(
                  carouselController: widget._controller,
                  itemCount: widget.top.length,
                  options: CarouselOptions(
                      height: 280.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        print(index);
                        top_idx = index;
                      }),
                  itemBuilder: (context, int itemIndex) {
                    if (widget.top.length == 0) return Container();
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            widget.top[itemIndex].thumbnail_url,
                                        fit: BoxFit.cover,
                                        httpHeaders: {
                                          HttpHeaders.refererHeader:
                                              "http://api-stride.com:5000/"
                                        },
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget
                                                  .top[itemIndex].product_name,
                                              style: subHeaderStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                                'Price ${widget.top[itemIndex].price}')
                                          ],
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceMediumLarge
                                    ]),
                              )
                            ],
                          ),
                        ]));
                  },
                ),
                UIHelper.verticalSpaceMedium,
                CarouselSlider.builder(
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: 280.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        print(index);
                        bottom_idx = index;
                      }),
                  itemCount: widget.bottom.length,
                  itemBuilder: (context, int itemIndex) {
                    if (widget.bottom.length == 0) return Container();
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        //decoration: BoxDecoration(color: Colors.amber),
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: CachedNetworkImage(
                                        imageUrl: widget
                                            .bottom[itemIndex].thumbnail_url,
                                        fit: BoxFit.cover,
                                        httpHeaders: {
                                          HttpHeaders.refererHeader:
                                              "http://api-stride.com:5000/"
                                        },
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.bottom[itemIndex]
                                                  .product_name,
                                              style: subHeaderStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                                'Price ${widget.bottom[itemIndex].price}')
                                          ],
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceMediumLarge
                                    ]),
                              )
                            ],
                          ),
                        ]));
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  width: double.infinity,
                  child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 12, 70, 12),
                      color: backgroundColor,
                      onPressed: () async {
                        Stride.analytics
                            .logEvent(name: 'DRESSROOM_SAVE_BUTTON_CLICKED');
                        setState(() {
                          page = "rename";
                        });
                      },
                      child: Container(
                        child: Text(
                          'SAVE',
                          style: whiteStyle,
                        ),
                      )
                      //Text('Save', style: whiteStyle),
                      ),
                ),
              ],
            )),
      );
    } else {
      showWidget = Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Center(
                    child: Text(
                      '룩북 만들기',
                      style: headerStyle,
                    ),
                  ),
                  leading: FlatButton(
                      child: Image.asset(
                        'images/left-arrow.png',
                        width: 15,
                        height: 15,
                      ),
                      //icon: FaIcon(FontAwesomeIcons.folderPlus),
                      onPressed: () {
                        setState(() {
                          page = "default";
                        });
                      }),
                  trailing: FlatButton(
                      child: Image.asset(
                        'images/left-arrow.png',
                        width: 15,
                        height: 15,
                        color: Colors.transparent,
                      ),
                      //icon: FaIcon(FontAwesomeIcons.folderPlus),
                      onPressed: () {
                        setState(() {
                          page = "default";
                        });
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: _renameTextController,
                    onSubmitted: (String text) async {
                      Stride.analytics
                          .logEvent(name: "DRESSROOM_MAKE_COORDINATE");
                      await Provider.of<LookBookService>(context, listen: false)
                          .addItem(
                              widget.top[top_idx],
                              widget.bottom[bottom_idx],
                              _renameTextController.text);
                      ServiceView.scaffoldKey.currentState
                          .showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 1500),
                              content: Row(children: [
                                Icon(
                                  Icons.check,
                                  color: backgroundColor,
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Text('룩북에 저장되었습니다.'),
                              ])));
                      Navigator.maybePop(context);
                    },
                    decoration: InputDecoration.collapsed(hintText: "새로운 이름"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                  child: Text(
                    '룩북 이름은 열 글자 이내로 제한됩니다.',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    Stride.analytics
                        .logEvent(name: "DRESSROOM_MAKE_COORDINATE");
                    await Provider.of<LookBookService>(context, listen: false)
                        .addItem(widget.top[top_idx], widget.bottom[bottom_idx],
                            _renameTextController.text);
                    ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 1500),
                        content: Row(children: [
                          Icon(
                            Icons.check,
                            color: backgroundColor,
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Text('룩북에 저장되었습니다.'),
                        ])));
                    Navigator.maybePop(context);
                  },
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  color: backgroundColor,
                  child: Text(
                    '확인',
                    style: whiteStyle,
                  ),
                )
              ],
            )),
      );
    }
    return showWidget;
  }
}
