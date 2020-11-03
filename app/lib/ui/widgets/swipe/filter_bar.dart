import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:app/ui/widgets/filter/color.dart';
import 'package:app/ui/widgets/filter/concept.dart';
import 'package:app/ui/widgets/filter/price.dart';
import 'package:app/ui/widgets/filter/size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> MENU = ['옷 종류', '컨셉', '가격', '색상', '사이즈'];

Widget FilterBar(SwipeModel model, BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '필터설정',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  '옷 종류',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                ClothTypeFilter(model),
                Divider(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '컨셉',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(child: ConceptFilter(model)),
                Divider(),
                SizedBox(
                  height: 16,
                ),
                PriceFilter(model),
                Divider(),
                Text(
                  '색상',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(child: ColorFilter(model)),
                Divider(),
                Text(
                  '사이즈',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(child: SizeFilter(model)),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    model.setFilter();
                    filter_flush.show(context);
                    Navigator.maybePop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF2B3341)),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}
// return Container(
//   height: 30,
//   margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
//   child: Row(children: [
//     Expanded(
//       child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: List.generate(MENU.length, (index) {
//             return InkWell(
//                 onTap: () {
//                   showModalBottomSheet(
//                       isScrollControlled: true,
//                       context: context,
//                       builder: (context) {
//                         var user = Provider.of<AuthenticationService>(context,
//                                 listen: false)
//                             .userController
//                             .value;
//                         return FractionallySizedBox(
//                           heightFactor: 0.65,
//                           child: Stack(children: [
//                             DefaultTabController(
//                               initialIndex: index,
//                               length: 5,
//                               child: Scaffold(
//                                 backgroundColor: Colors.white,
//                                 appBar: PreferredSize(
//                                   preferredSize: Size.fromHeight(60),
//                                   child: AppBar(
//                                       automaticallyImplyLeading: false,
//                                       backgroundColor: Colors.white,
//                                       elevation: 0,
//                                       bottom: TabBar(
//                                           labelColor: Colors.black,
//                                           unselectedLabelColor:
//                                               Colors.black38,
//                                           indicatorColor: Colors.black,
//                                           tabs: [
//                                             Tab(
//                                               child: Text(
//                                                 '옷 종류',
//                                               ),
//                                             ),
//                                             Tab(
//                                               child: Text(
//                                                 '컨셉',
//                                               ),
//                                             ),
//                                             Tab(
//                                               child: Text('가격'),
//                                             ),
//                                             Tab(
//                                               child: Text('색상'),
//                                             ),
//                                             Tab(
//                                               child: Text('사이즈'),
//                                             )
//                                           ])),
//                                 ),
//                                 body: TabBarView(
//                                   children: [
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 66),
//                                         child: Center(
//                                             child: ClothTypeFilter(model))),
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 66),
//                                         child: Center(
//                                             child: ConceptFilter(model))),
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 66),
//                                         child: PriceFilter(model)),
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 66),
//                                         child: Center(
//                                             child: ColorFilter(model))),
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 66),
//                                         child:
//                                             Center(child: SizeFilter(model)))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.topCenter,
//                               child: Padding(
//                                 padding: EdgeInsets.all(8),
//                                 child: Container(
//                                   width: 50,
//                                   height: 3,
//                                   decoration: BoxDecoration(
//                                       color: Colors.black12,
//                                       borderRadius: BorderRadius.circular(8)),
//                                 ),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: Padding(
//                                 padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
//                                 child: FlatButton(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(15)),
//                                     padding:
//                                         EdgeInsets.fromLTRB(50, 5, 50, 5),
//                                     color: Colors.black,
//                                     onPressed: () {
//                                       model.setFilter();
//                                       Navigator.maybePop(context);
//                                     },
//                                     child: Text(
//                                       '적용하기',
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 16),
//                                     )),
//                               ),
//                             )
//                           ]),
//                         );
//                       });
//                 },
//                 child: Container(
//                     margin: EdgeInsets.only(right: 10),
//                     padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                     constraints: BoxConstraints(minWidth: 50),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         border: model.isNotChangedFilter(index)
//                             ? Border.all(color: Colors.black12)
//                             : Border.all(color: Colors.black)),
//                     child: Center(
//                         child: Container(
//                       child: Text(MENU[index],
//                           style: model.isNotChangedFilter(index)
//                               ? TextStyle(color: Colors.black38)
//                               : TextStyle(color: Colors.black)),
//                     ))));
//           })),
//     ),
//   ]),
// );
