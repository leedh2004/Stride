import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:app/ui/widgets/filter/concept.dart';
import 'package:app/ui/widgets/filter/price.dart';
import 'package:app/ui/widgets/filter/size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> MENU = ['옷 종류', '컨셉', '가격', '색상', '신상품', '사이즈'];

Widget clothTypeBar(SwipeModel model, BuildContext context) {
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
                            heightFactor: 0.7,
                            child: Stack(children: [
                              DefaultTabController(
                                length: 5,
                                child: Scaffold(
                                  appBar: AppBar(
                                      automaticallyImplyLeading: false,
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      title: Text('필터',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      bottom: TabBar(
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Colors.black38,
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
                                  body: TabBarView(
                                    children: [
                                      ClothTypeFilter(),
                                      ConceptFilter(),
                                      PriceFilter(),
                                      Icon(Icons.directions_transit),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 66),
                                          child: SizeFilter(user))
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 14),
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding:
                                          EdgeInsets.fromLTRB(50, 5, 50, 5),
                                      color: Colors.black,
                                      onPressed: () {
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
                          border: Border.all(color: Colors.black12)),
                      child: Center(
                          child: Container(
                        child: Text(
                          MENU[index],
                          style: TextStyle(color: Colors.black38),
                        ),
                      ))));
              // return InkWell(
              //   onTap: () {
              //     model.changeType(TYPE[index]);
              //     Stride.analytics.logEvent(
              //       name: 'SWIPE_CLOTH_TYPE_CHANGE_${TYPE[index]}',
              //     );
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //     child: Text(
              //       '${TYPE[index][0].toUpperCase() + TYPE[index].substring(1)}',
              //       style: model.type == TYPE[index]
              //           ? subHeaderMainColorStyle
              //           : subHeaderStyle,
              //     ),
              //   ),
              // );
            })),
      ),
      // Container(
      //     margin: EdgeInsets.only(left: 10),
      //     child: Text(
      //       '>',
      //       style: subHeaderStyle,
      //     ))
    ]),
  );
}
