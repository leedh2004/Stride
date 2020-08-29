import 'dart:io';
import 'package:app/core/models/product.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DressRoomSelectDialog extends StatelessWidget {
  final List<Product> top;
  final List<Product> bottom;
  final CarouselController _controller = CarouselController();
  int top_idx = 0;
  int bottom_idx = 0;
  DressRoomSelectDialog(this.top, this.bottom);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 650,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: top.length,
            options: CarouselOptions(
                height: 280.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  print(index);
                  top_idx = index;
                }),
            itemBuilder: (context, int itemIndex) {
              if (top.length == 0) return Container();
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black45, width: 0.5)),
                    elevation: 1,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                              aspectRatio: 12 / 8,
                              child: CachedNetworkImage(
                                imageUrl: top[itemIndex].thumbnail_url,
                                fit: BoxFit.cover,
                                httpHeaders: {
                                  HttpHeaders.refererHeader:
                                      "http://api-stride.com:5000/"
                                },
                              )),
                          Padding(
                            padding: EdgeInsets.all(10),
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
                                          top[itemIndex].product_name,
                                          style: subHeaderStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text('Price ${top[itemIndex].price}')
                                      ],
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceMediumLarge
                                ]),
                          )
                        ],
                      ),
                    ]),
                  ));
            },
          ),
          UIHelper.verticalSpaceMedium,
          CarouselSlider.builder(
            options: CarouselOptions(
                height: 280.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  bottom_idx = index;
                }),
            itemCount: bottom.length,
            itemBuilder: (context, int itemIndex) {
              if (bottom.length == 0) return Container();
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  //decoration: BoxDecoration(color: Colors.amber),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black45, width: 0.5)),
                    elevation: 1,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                              aspectRatio: 12 / 8,
                              child: CachedNetworkImage(
                                imageUrl: bottom[itemIndex].thumbnail_url,
                                fit: BoxFit.cover,
                                httpHeaders: {
                                  HttpHeaders.refererHeader:
                                      "http://api-stride.com:5000/"
                                },
                              )
                              // Image.network(
                              //   item.thumbnail_url,
                              //   fit: BoxFit.cover,
                              // )
                              ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
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
                                            bottom[itemIndex].product_name,
                                            style: subHeaderStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                              'Price ${bottom[itemIndex].price}')
                                        ],
                                      ),
                                    ),
                                    UIHelper.horizontalSpaceMediumLarge
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ]),
                  ));
            },
          ),
          RaisedButton(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
              color: backgroundColor,
              onPressed: () async {
                print(top[top_idx].product_name);
                print(bottom[bottom_idx].product_name);

                Provider.of<LookBookService>(context, listen: false)
                    .addItem(top[top_idx], bottom[bottom_idx]);
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
                Navigator.pop(context);
              },
              child: FaIcon(
                FontAwesomeIcons.chevronCircleDown,
                color: Colors.white,
              )
              //Text('Save', style: whiteStyle),
              ),
        ],
      )),
    );
  }
}
