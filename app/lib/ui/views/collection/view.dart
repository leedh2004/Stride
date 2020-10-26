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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            '콜렉션',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16),
        child: FloatingActionButton(
          backgroundColor: Color.fromRGBO(128, 108, 231, 1),
          onPressed: () {},
          child: Icon(
            Icons.add,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: TabBar(
                      labelColor: Color.fromRGBO(128, 108, 231, 1),
                      unselectedLabelColor: Colors.black38,
                      indicatorColor: Color.fromRGBO(128, 108, 231, 1),
                      tabs: [
                        Tab(
                          child: Text(
                            '콜렉션',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '룩북',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: DressRoomFolderView()),
                Padding(
                    padding: EdgeInsets.only(top: 24), child: LookBookView())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const currentStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700);
const notCurrentStyle =
    TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w700);
