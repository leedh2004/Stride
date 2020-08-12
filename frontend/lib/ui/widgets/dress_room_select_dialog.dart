import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';

class DressRoomSelectDialog extends StatelessWidget {
  final List<Product> top;
  final List<Product> bottom;

  DressRoomSelectDialog(this.top, this.bottom);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 650,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(height: 280.0),
            items: top.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Colors.black45, width: 0.5)),
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                  aspectRatio: 12 / 8,
                                  child: Image.network(
                                    item.thumbnail_url,
                                    fit: BoxFit.cover,
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
                                              item.product_name,
                                              style: subHeaderStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text('Price ${item.price}')
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
              );
            }).toList(),
          ),
          UIHelper.verticalSpaceMedium,
          CarouselSlider(
            options: CarouselOptions(height: 280.0),
            items: bottom.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      //decoration: BoxDecoration(color: Colors.amber),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Colors.black45, width: 0.5)),
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 12 / 8,
                                child: FancyShimmerImage(
                                  imageUrl: item.thumbnail_url,
                                  boxFit: BoxFit.cover,
                                  errorWidget: Icon(Icons.error),
                                  shimmerBaseColor: backgroundTransparentColor,
                                  shimmerHighlightColor: backgroundColor,
                                  shimmerBackColor: backgroundColor,
                                  // placeholder: (context, url) => LoadingWidget(),
                                ),
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
                                                item.product_name,
                                                style: subHeaderStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text('Price ${item.price}')
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
              );
            }).toList(),
          ),
          RaisedButton(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
            color: backgroundColor,
            onPressed: () {},
            child: Text('Save', style: whiteStyle),
          )
        ],
      )),
    );
  }
}
