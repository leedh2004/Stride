import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/recent_item.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/product_web_view.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '최근에 평가한 아이템',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFF4F4FC)),
                child: Center(
                  child: Text(
                    '최근 3개월 동안 평가한 아이템 목록입니다.',
                    style: TextStyle(color: Color(0xFF8569EF)),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              BaseWidget<RecentItemModel>(
                  model: RecentItemModel(Provider.of(context, listen: false),
                      Provider.of(context, listen: false)),
                  builder: (context, model, child) {
                    return Flexible(
                      child: GridView.count(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.5,
                          crossAxisSpacing: 15,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: items.map((item) {
                            return InkWell(
                                onTap: () async {
                                  final result = Navigator.push(context,
                                      MaterialPageRoute<String>(
                                          builder: (BuildContext context) {
                                    return RecentDetailInfo(item, model, true);
                                  }));

                                  if (await result == 'collect') {
                                    // ServiceView.scaffoldKey.currentState
                                    //     .showSnackBar(SnackBar(
                                    //   duration: Duration(milliseconds: 1500),
                                    //   content: Text('해당상품이 콜렉션에 추가되었습니다.'),
                                    // ));
                                    collection_flush.show(context);
                                  }
                                  setState(() {});
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(children: [
                                          Positioned.fill(
                                            child: Hero(
                                              tag: item.product_id,
                                              child: CachedNetworkImage(
                                                imageUrl: item
                                                    .compressed_thumbnail_url,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: item.likes
                                                  ? Image.asset(
                                                      'assets/heart_button_s.png',
                                                      width: 36,
                                                      height: 36,
                                                    )
                                                  : Container())
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('${item.product_name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('${item.price}원',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )
                                // child: Container(
                                //   child: Hero(
                                //     tag: item.product_id,
                                //     // tag: item.image_urls[0],
                                //     child: CachedNetworkImage(
                                //       imageUrl: item.compressed_thumbnail_url,
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                // )
                                );
                          }).toList()),
                    );
                  }),
            ]),
          ),
        ));
  }
}
