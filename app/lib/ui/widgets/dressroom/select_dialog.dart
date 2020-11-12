import 'dart:io';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/widgets/dressroom/lookbook_create_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  TextEditingController _renameTextController = TextEditingController();
  int top_idx = 0;
  int bottom_idx = 0;

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    showWidget = Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 10,
            ),
            Text(
              '룩북 만들기',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              '원하는 코디를 매칭해보세요',
              style: TextStyle(color: Color(0xFF5125BA), fontSize: 12),
            ),
          ]),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                child: Image.asset(
                  'assets/close.png',
                  width: 15,
                  height: 15,
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xFFFAF9FC),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CarouselSlider.builder(
                  carouselController: widget._controller,
                  itemCount: widget.top.length,
                  options: CarouselOptions(
                      height: 260.0,
                      viewportFraction: 0.6,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          top_idx = index;
                        });
                      }),
                  itemBuilder: (context, int itemIndex) {
                    if (widget.top.length == 0) return Container();
                    return Center(
                      child: Container(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: top_idx == itemIndex ? 190 : 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: top_idx == itemIndex
                                        ? Color(0xFF8569EF)
                                        : Colors.transparent,
                                    width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: widget.top[itemIndex].thumbnail_url,
                                  fit: BoxFit.cover,
                                  httpHeaders: {
                                    HttpHeaders.refererHeader:
                                        "http://api-stride.com:5000/"
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.top[itemIndex].product_name,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(children: [
                                  Text(
                                    '${widget.top[itemIndex].price}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    '원',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  )
                                ])
                              ],
                            ),
                          )
                        ],
                      )),
                    );
                  },
                ),
                Divider(),
                CarouselSlider.builder(
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: 260.0,
                      viewportFraction: 0.6,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          bottom_idx = index;
                        });
                      }),
                  itemCount: widget.bottom.length,
                  itemBuilder: (context, int itemIndex) {
                    if (widget.bottom.length == 0) return Container();
                    return Center(
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: bottom_idx == itemIndex ? 190 : 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: bottom_idx == itemIndex
                                            ? Color(0xFF8569EF)
                                            : Colors.transparent,
                                        width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: widget
                                          .bottom[itemIndex].thumbnail_url,
                                      fit: BoxFit.cover,
                                      httpHeaders: {
                                        HttpHeaders.refererHeader:
                                            "http://api-stride.com:5000/"
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      widget.bottom[itemIndex].product_name,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(children: [
                                      Text(
                                        '${widget.bottom[itemIndex].price}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        '원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      )
                                    ])
                                  ],
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF8569EF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 54,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () async {
                          Stride.logEvent(
                              name: 'DRESSROOM_SAVE_BUTTON_CLICKED');
                          await showMaterialModalBottomSheet(
                              context: (context),
                              builder: (context, scrollContext) {
                                return LookBookCreateDialog(widget.top[top_idx],
                                    widget.bottom[bottom_idx]);
                              });
                          // lookbook_flush.show(context);
                          // setState(() {
                          //   page = "rename";
                          // });
                        },
                        child: Center(
                          child: Text(
                            '저장하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                      //Text('Save', style: whiteStyle),
                      ),
                ),
              ],
            )),
      ),
    );

    //   showWidget = Container(
    //     padding: EdgeInsets.all(0),
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.all(Radius.circular(20))),
    //     child: Padding(
    //         padding: EdgeInsets.only(
    //             bottom: MediaQuery.of(context).viewInsets.bottom),
    //         child: ListView(
    //           padding: EdgeInsets.all(0),
    //           shrinkWrap: true,
    //           children: [
    //             ListTile(
    //               title: Center(
    //                 child: Text(
    //                   '룩북 만들기',
    //                   style: headerStyle,
    //                 ),
    //               ),
    //               leading: FlatButton(
    //                   child: Image.asset(
    //                     'images/left-arrow.png',
    //                     width: 15,
    //                     height: 15,
    //                   ),
    //                   //icon: FaIcon(FontAwesomeIcons.folderPlus),
    //                   onPressed: () {
    //                     setState(() {
    //                       page = "default";
    //                     });
    //                   }),
    //               trailing: FlatButton(
    //                   child: Image.asset(
    //                     'images/left-arrow.png',
    //                     width: 15,
    //                     height: 15,
    //                     color: Colors.transparent,
    //                   ),
    //                   //icon: FaIcon(FontAwesomeIcons.folderPlus),
    //                   onPressed: () {
    //                     setState(() {
    //                       page = "default";
    //                     });
    //                   }),
    //             ),
    //             Container(
    //               padding: EdgeInsets.all(12),
    //               child: TextField(
    //                 autofocus: true,
    //                 inputFormatters: [
    //                   LengthLimitingTextInputFormatter(10),
    //                 ],
    //                 controller: _renameTextController,
    //                 onSubmitted: (String text) async {
    //                   Stride.logEvent(name: "DRESSROOM_MAKE_COORDINATE");
    //                   await Provider.of<LookBookService>(context, listen: false)
    //                       .addItem(
    //                           widget.top[top_idx],
    //                           widget.bottom[bottom_idx],
    //                           _renameTextController.text);
    //                   ServiceView.scaffoldKey.currentState
    //                       .showSnackBar(SnackBar(
    //                           duration: Duration(milliseconds: 1500),
    //                           content: Row(children: [
    //                             Icon(
    //                               Icons.check,
    //                               color: backgroundColor,
    //                             ),
    //                             UIHelper.horizontalSpaceMedium,
    //                             Text('룩북에 저장되었습니다.'),
    //                           ])));
    //                   Navigator.maybePop(context);
    //                 },
    //                 decoration: InputDecoration.collapsed(hintText: "새로운 이름"),
    //               ),
    //             ),
    //             Container(
    //               padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
    //               child: Text(
    //                 '룩북 이름은 열 글자 이내로 제한됩니다.',
    //                 style: TextStyle(color: Colors.black38),
    //               ),
    //             ),
    //             RaisedButton(
    //               onPressed: () async {
    //                 Stride.logEvent(name: "DRESSROOM_MAKE_COORDINATE");
    //                 await Provider.of<LookBookService>(context, listen: false)
    //                     .addItem(widget.top[top_idx], widget.bottom[bottom_idx],
    //                         _renameTextController.text);
    //                 ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
    //                     duration: Duration(milliseconds: 1500),
    //                     content: Row(children: [
    //                       Icon(
    //                         Icons.check,
    //                         color: backgroundColor,
    //                       ),
    //                       UIHelper.horizontalSpaceMedium,
    //                       Text('룩북에 저장되었습니다.'),
    //                     ])));
    //                 Navigator.maybePop(context);
    //               },
    //               padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
    //               color: backgroundColor,
    //               child: Text(
    //                 '확인',
    //                 style: whiteStyle,
    //               ),
    //             )
    //           ],
    //         )),
    //   );
    // }
    return showWidget;
  }
}
