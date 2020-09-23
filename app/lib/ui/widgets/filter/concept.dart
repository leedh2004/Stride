import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:flutter/material.dart';

class ConceptFilter extends StatefulWidget {
  @override
  _ConceptFilterState createState() => _ConceptFilterState();
}

class _ConceptFilterState extends State<ConceptFilter> {
  BoolWrapper all = BoolWrapper(true);
  BoolWrapper basic = BoolWrapper(false);
  BoolWrapper daily = BoolWrapper(false);
  BoolWrapper simple = BoolWrapper(false);
  BoolWrapper sik = BoolWrapper(false);
  BoolWrapper street = BoolWrapper(false);
  BoolWrapper romantic = BoolWrapper(false);
  BoolWrapper unique = BoolWrapper(false);
  BoolWrapper sexy = BoolWrapper(false);
  BoolWrapper vintage = BoolWrapper(false);

  Widget unSelectedWidget(String title, BoolWrapper type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (identical(type, all)) {
              basic.value = daily.value = simple.value = sik.value =
                  street.value = romantic.value =
                      unique.value = sexy.value = vintage.value = false;
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
            if (!(basic.value ||
                daily.value ||
                simple.value ||
                sik.value ||
                street.value ||
                romantic.value ||
                unique.value ||
                vintage.value ||
                sexy.value)) all.value = true;
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
      '자동': all,
      '베이직': basic,
      '데일리': daily,
      '심플': simple,
      '시크': sik,
      '스트릿': street,
      '로맨틱': romantic,
      '유니크': unique,
      '섹시': sexy,
      '빈티지': vintage,
    };
    List<String> keys = types.keys.toList();
    List<BoolWrapper> values = types.values.toList();
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '컨셉',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black26),
            ),
          ),
          Row(
            children: [
              all.value
                  ? selectedWidget('자동', all)
                  : unSelectedWidget('자동', all),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
          Row(
              children: List.generate(
                  keys.sublist(1, 4).length,
                  (index) => values[index + 1].value
                      ? selectedWidget(keys[index + 1], values[index + 1])
                      : unSelectedWidget(keys[index + 1], values[index + 1]))),
          Row(
              children: List.generate(
                  keys.sublist(4, 7).length,
                  (index) => values[index + 4].value
                      ? selectedWidget(keys[index + 4], values[index + 4])
                      : unSelectedWidget(keys[index + 4], values[index + 4]))),
          Row(
              children: List.generate(
                  keys.sublist(7, 10).length,
                  (index) => values[index + 7].value
                      ? selectedWidget(keys[index + 7], values[index + 7])
                      : unSelectedWidget(keys[index + 7], values[index + 7]))),
        ]);
  }
}
