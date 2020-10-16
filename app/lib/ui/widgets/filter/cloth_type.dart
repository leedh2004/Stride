import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BoolWrapper {
  bool value;
  BoolWrapper(bool _value) {
    value = _value;
  }
}

class ClothTypeFilter extends StatefulWidget {
  SwipeModel model;
  ClothTypeFilter(this.model);
  @override
  _ClothTypeFilterState createState() => _ClothTypeFilterState();
}

class _ClothTypeFilterState extends State<ClothTypeFilter> {
  BoolWrapper all;
  BoolWrapper top;
  BoolWrapper skirt;
  BoolWrapper pants;
  BoolWrapper dress;
  BoolWrapper outer;

  Widget unSelectedWidget(String title, BoolWrapper type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (identical(type, all)) {
            top.value =
                skirt.value = pants.value = dress.value = outer.value = false;
          } else if (all.value == true) {
            all.value = false;
          }
          type.value = true;
          List<String> types = new List();
          all.value ? types.add('all') : null;
          top.value ? types.add('top') : null;
          skirt.value ? types.add('skirt') : null;
          pants.value ? types.add('pants') : null;
          dress.value ? types.add('dress') : null;
          outer.value ? types.add('outer') : null;
          widget.model.setClothTypes(types);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12)),
          child: Center(
              child: Text(
            title,
            style:
                TextStyle(color: Colors.black26, fontWeight: FontWeight.w700),
          )),
        ),
      ),
    );
  }

  Widget selectedWidget(String title, BoolWrapper type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          type.value = false;
          if (!(all.value ||
              top.value ||
              skirt.value ||
              pants.value ||
              dress.value ||
              outer.value)) all.value = true;
          List<String> types = new List();
          all.value ? types.add('all') : null;
          top.value ? types.add('top') : null;
          skirt.value ? types.add('skirt') : null;
          pants.value ? types.add('pants') : null;
          dress.value ? types.add('dress') : null;
          outer.value ? types.add('outer') : null;
          widget.model.setClothTypes(types);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black)),
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    all = BoolWrapper(widget.model.filter.types.contains('all'));
    top = BoolWrapper(widget.model.filter.types.contains('top'));
    pants = BoolWrapper(widget.model.filter.types.contains('pants'));
    skirt = BoolWrapper(widget.model.filter.types.contains('skirt'));
    dress = BoolWrapper(widget.model.filter.types.contains('dress'));
    outer = BoolWrapper(widget.model.filter.types.contains('outer'));
    Map<String, BoolWrapper> types = {
      '전체': all,
      '상의': top,
      '하의': pants,
      '치마': skirt,
      '원피스': dress,
      '아우터': outer
    };
    List<String> keys = types.keys.toList();
    List<BoolWrapper> values = types.values.toList();
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: Text(
          //     '옷 종류',
          //     style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black26),
          //   ),
          // ),
          Row(
              children: List.generate(
                  keys.sublist(0, 3).length,
                  (index) => values[index].value
                      ? selectedWidget(keys[index], values[index])
                      : unSelectedWidget(keys[index], values[index]))),
          Row(
              children: List.generate(
                  keys.sublist(3, 6).length,
                  (index) => values[index + 3].value
                      ? selectedWidget(keys[index + 3], values[index + 3])
                      : unSelectedWidget(keys[index + 3], values[index + 3]))),
        ]);
  }
}

// class ClothTypeFilter extends StatelessWidget {
//   SwipeModel model;
//   ClothTypeFilter(this.model);

//   BoolWrapper all;
//   BoolWrapper top;
//   BoolWrapper skirt;
//   BoolWrapper pants;
//   BoolWrapper dress;
//   BoolWrapper outer;

// }

// class ClothTypeFilter extends StatefulWidget {
//   SwipeModel model;
//   ClothTypeFilter(this.model);
//   @override
//   _ClothTypeFilterState createState() => _ClothTypeFilterState();
// }

// class _ClothTypeFilterState extends State<ClothTypeFilter> {
//   BoolWrapper all = BoolWrapper(true);
//   BoolWrapper top = BoolWrapper(false);
//   BoolWrapper skirt = BoolWrapper(false);
//   BoolWrapper pants = BoolWrapper(false);
//   BoolWrapper dress = BoolWrapper(false);
//   BoolWrapper outer = BoolWrapper(false);

//   Widget unSelectedWidget(String title, BoolWrapper type) {
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             if (identical(type, all)) {
//               top.value =
//                   skirt.value = pants.value = dress.value = outer.value = false;
//             } else if (all.value == true) {
//               all.value = false;
//             }
//             type.value = true;
//             List<String> types = new List();
//             all.value ? types.add('all') : null;
//             top.value ? types.add('top') : null;
//             skirt.value ? types.add('skirt') : null;
//             pants.value ? types.add('pants') : null;
//             dress.value ? types.add('dress') : null;
//             outer.value ? types.add('outer') : null;
//             widget.model.setClothTypes(types);
//           });
//         },
//         child: Container(
//           margin: EdgeInsets.all(8),
//           height: 40,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.black12)),
//           child: Center(
//               child: Text(
//             title,
//             style:
//                 TextStyle(color: Colors.black26, fontWeight: FontWeight.w700),
//           )),
//         ),
//       ),
//     );
//   }

//   Widget selectedWidget(String title, BoolWrapper type) {
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             type.value = false;
//             if (!(all.value ||
//                 top.value ||
//                 skirt.value ||
//                 pants.value ||
//                 dress.value ||
//                 outer.value)) all.value = true;
//           });
//         },
//         child: Container(
//           margin: EdgeInsets.all(8),
//           height: 40,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.black)),
//           child: Center(
//               child: Text(
//             title,
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
//           )),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map<String, BoolWrapper> types = {
//       '전체': all,
//       '상의': top,
//       '하의': pants,
//       '치마': skirt,
//       '원피스': dress,
//       '아우터': outer
//     };
//     List<String> keys = types.keys.toList();
//     List<BoolWrapper> values = types.values.toList();
//     return Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               '옷 종류',
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black26),
//             ),
//           ),
//           Row(
//               children: List.generate(
//                   keys.sublist(0, 3).length,
//                   (index) => values[index].value
//                       ? selectedWidget(keys[index], values[index])
//                       : unSelectedWidget(keys[index], values[index]))),
//           Row(
//               children: List.generate(
//                   keys.sublist(3, 6).length,
//                   (index) => values[index + 3].value
//                       ? selectedWidget(keys[index + 3], values[index + 3])
//                       : unSelectedWidget(keys[index + 3], values[index + 3]))),
//         ]);
//   }
// }
