import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/recent_item.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/views/swipe/info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class RecentItemView extends StatefulWidget {
  @override
  _RecentItemViewState createState() => _RecentItemViewState();
}

class _RecentItemViewState extends State<RecentItemView> {
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController;
  List<RecentItem> items = new List();

  _scrollListener() async {
    var recentService = Provider.of<RecentItemService>(context, listen: false);
    if (_scrollController.offset + 10 >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      items += await RecentItemModel(
              recentService, Provider.of(context, listen: false))
          .addItem(pageCount);
      recentService.addItem(pageCount);
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;
        if (isLoading) {
          print("RUNNING LOAD MORE");
          pageCount = pageCount + 1;
        }
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: backgroundColor,
          title: Text('최근에 평가한 아이템'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 5),
          child: BaseWidget<RecentItemModel>(
              model: RecentItemModel(Provider.of(context, listen: false),
                  Provider.of(context, listen: false)),
              builder: (context, model, child) {
                return GridView.count(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: items.map((item) {
                      print(item.likes_time);
                      return InkWell(
                          onTap: () async {
                            final result = Navigator.push(context,
                                MaterialPageRoute<String>(
                                    builder: (BuildContext context) {
                              return RecentDetailInfo(item, model);
                            }));

                            if (await result == 'collect') {
                              //                           RecentItem item =
                              //     Provider.of<SwipeService>(context, listen: false).items[model.index];
                              // model.addItem(item);
                              ServiceView.scaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 1500),
                                content: Text('해당상품이 콜렉션에 추가되었습니다.'),
                              ));
                            }
                          },
                          child: Container(
                            child: Hero(
                              tag: item.product_id,
                              // tag: item.image_urls[0],
                              child: CachedNetworkImage(
                                imageUrl: item.compressed_thumbnail_url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ));
                    }).toList());
              }),
        ));
  }
}
