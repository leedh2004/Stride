import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:app/ui/widgets/filter/color.dart';
import 'package:app/ui/widgets/filter/concept.dart';
import 'package:app/ui/widgets/filter/price.dart';
import 'package:app/ui/widgets/filter/size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> MENU = ['옷 종류', '컨셉', '가격', '색상', '사이즈'];

Widget FilterBar(SwipeModel model, BuildContext context) {
  return Container(
    height: 30,
    margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
    child: Row(children: [
      Expanded(
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(MENU.length, (index) {
              return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          var user = Provider.of<AuthenticationService>(context,
                                  listen: false)
                              .userController
                              .value;
                          return FractionallySizedBox(
                            heightFactor: 0.55,
                            child: Stack(children: [
                              DefaultTabController(
                                initialIndex: index,
                                length: 5,
                                child: Scaffold(
                                  backgroundColor: Colors.white,
                                  appBar: PreferredSize(
                                    preferredSize: Size.fromHeight(60),
                                    child: AppBar(
                                        automaticallyImplyLeading: false,
                                        backgroundColor: Colors.white,
                                        elevation: 0,
                                        // title: Text('필터',
                                        //     style:
                                        //         TextStyle(color: Colors.black)),
                                        bottom: TabBar(
                                            labelColor: Colors.black,
                                            unselectedLabelColor:
                                                Colors.black38,
                                            indicatorColor: Colors.black,
                                            tabs: [
                                              Tab(
                                                child: Text(
                                                  '옷 종류',
                                                ),
                                              ),
                                              Tab(
                                                child: Text(
                                                  '컨셉',
                                                ),
                                              ),
                                              Tab(
                                                child: Text('가격'),
                                              ),
                                              Tab(
                                                child: Text('색상'),
                                              ),
                                              Tab(
                                                child: Text('사이즈'),
                                              )
                                            ])),
                                  ),
                                  body: TabBarView(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child: Center(
                                              child: ClothTypeFilter(model))),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child: Center(
                                              child: ConceptFilter(model))),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child: PriceFilter(model)),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child: Center(
                                              child: ColorFilter(model))),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child:
                                              Center(child: SizeFilter(model)))
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    width: 50,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomLeft,
                              //   child: Padding(
                              //     padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
                              //     child: FlatButton(
                              //         padding:
                              //             EdgeInsets.fromLTRB(10, 5, 10, 5),
                              //         onPressed: () {
                              //           model.setInitFilter();
                              //         },
                              //         child: Text(
                              //           '전체 초기화',
                              //           style: TextStyle(
                              //               color: Colors.black54,
                              //               fontSize: 14),
                              //         )),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding:
                                          EdgeInsets.fromLTRB(50, 5, 50, 5),
                                      color: Colors.black,
                                      onPressed: () {
                                        model.setFilter();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '적용하기',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                                ),
                              )
                            ]),
                          );
                        });
                    // model.changeFolder(folderKey);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      constraints: BoxConstraints(minWidth: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: model.isNotChangedFilter(index)
                              ? Border.all(color: Colors.black12)
                              : Border.all(color: Colors.black)),
                      child: Center(
                          child: Container(
                        child: Text(MENU[index],
                            style: model.isNotChangedFilter(index)
                                ? TextStyle(color: Colors.black38)
                                : TextStyle(color: Colors.black)),
                      ))));
            })),
      ),
    ]),
  );
}
