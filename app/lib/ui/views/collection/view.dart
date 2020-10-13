import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:app/ui/views/lookbook/view.dart';
import 'package:flutter/material.dart';

class CollectionView extends StatefulWidget {
  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  var page = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(
                  width: 200,
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black38,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Text(
                          '콜렉션',
                          style: currentStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '룩북',
                          style: currentStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [DressRoomView(), LookBookView()],
        ),
      ),
    );

    // return Container(
    //   child: Column(
    //     children: [
    //       // SizedBox(
    //       //   height: 8,
    //       // ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             flex: 4,
    //             child: Align(
    //               alignment: Alignment.centerRight,
    //               child: InkWell(
    //                 onTap: () {
    //                   setState(() {
    //                     page = 0;
    //                   });
    //                 },
    //                 child: Padding(
    //                   padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
    //                   child: Text('콜렉션',
    //                       style: page == 0 ? currentStyle : notCurrentStyle),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           // ),
    //           Expanded(
    //             flex: 4,
    //             child: Align(
    //               alignment: Alignment.centerLeft,
    //               child: InkWell(
    //                 onTap: () {
    //                   setState(() {
    //                     page = 1;
    //                   });
    //                 },
    //                 child: Padding(
    //                   padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
    //                   child: Text('룩북',
    //                       style: page == 1 ? currentStyle : notCurrentStyle),
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //       page == 0 ? DressRoomView() : LookBookView()
    //     ],
    //   ),
    // );
  }
}

const currentStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
const notCurrentStyle =
    TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w700);
