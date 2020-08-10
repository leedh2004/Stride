import 'dart:convert';
import 'dart:io';

import 'package:app/core/models/product.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DressRoomSelectDialog extends StatelessWidget {
  final List<Product> top;
  final List<Product> bottom;
  int top_idx = 0;
  int bottom_idx = 0;
  // CarouselController topController = CarouselController();
  // CarouselController bottomController = CarouselController();
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
            itemCount: top.length,
            options: CarouselOptions(height: 280.0),
            itemBuilder: (context, int itemIndex) {
              top_idx = itemIndex;
              print(top_idx);

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
                              child: Image.network(
                                top[itemIndex].thumbnail_url,
                                fit: BoxFit.cover,
                                headers: {
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
            options: CarouselOptions(height: 280.0),
            itemCount: bottom.length,
            itemBuilder: (context, int itemIndex) {
              bottom_idx = itemIndex;
              print(bottom_idx);
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
                              child: Image.network(
                                bottom[itemIndex].thumbnail_url,
                                fit: BoxFit.cover,
                                headers: {
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
              // Provider.of<DressRoomModel>(context, listen: false)
              //     .makeCoordinate(top_idx, bottom_idx);
              FlutterSecureStorage _storage = new FlutterSecureStorage();
              String token = await _storage.read(key: 'jwt_token');
              final response = await http.post('${Api.endpoint}/coordination/',
                  headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    'Authorization': "Bearer ${token}",
                  },
                  body: jsonEncode({
                    'top_product_id': top[top_idx].product_id,
                    'bottom_product_id': bottom[bottom_idx].product_id,
                    'name': '나만의 룩'
                  }));
              print(response.statusCode);
              print(top[top_idx].product_id);
              print(bottom[bottom_idx].product_id);
            },
            child: Text('Save', style: whiteStyle),
          )
        ],
      )),
    );
  }
}
