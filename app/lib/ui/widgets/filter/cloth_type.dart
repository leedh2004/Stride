import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BoolWrapper {
  bool value;
  BoolWrapper(bool _value) {
    value = _value;
  }
}

class ClothTypeFilter extends StatefulWidget {
  @override
  _ClothTypeFilterState createState() => _ClothTypeFilterState();
}

class _ClothTypeFilterState extends State<ClothTypeFilter> {
  BoolWrapper all = BoolWrapper(true);
  BoolWrapper top = BoolWrapper(false);
  BoolWrapper skirt = BoolWrapper(false);
  BoolWrapper pants = BoolWrapper(false);
  BoolWrapper dress = BoolWrapper(false);
  BoolWrapper outer = BoolWrapper(false);

  Widget unSelectedWidget(String title, BoolWrapper type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (identical(type, all)) {
              top.value =
                  skirt.value = pants.value = dress.value = outer.value = false;
            } else if (all.value == true) {
              all.value = false;
            }
            type.value = true;
          });
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
          setState(() {
            type.value = false;
            if (!(all.value ||
                top.value ||
                skirt.value ||
                pants.value ||
                dress.value ||
                outer.value)) all.value = true;
          });
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
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '옷 종류',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black26),
            ),
          ),
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
