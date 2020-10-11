import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/widgets/filter/cloth_type.dart';
import 'package:flutter/material.dart';

class ConceptFilter extends StatefulWidget {
  SwipeModel model;
  ConceptFilter(this.model);
  @override
  _ConceptFilterState createState() => _ConceptFilterState();
}

class _ConceptFilterState extends State<ConceptFilter> {
  BoolWrapper all;
  BoolWrapper basic;
  BoolWrapper daily;
  BoolWrapper simple;
  BoolWrapper sik;
  BoolWrapper street;
  BoolWrapper romantic;
  BoolWrapper unique;
  BoolWrapper sexy;
  BoolWrapper vintage;

  Widget unSelectedWidget(String title, BoolWrapper type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (identical(type, all)) {
            basic.value = daily.value = simple.value = sik.value =
                street.value = romantic.value =
                    unique.value = sexy.value = vintage.value = false;
          } else if (all.value == true) {
            all.value = false;
          }
          type.value = true;
          List<String> concepts = new List();
          all.value ? concepts.add('all') : null;
          basic.value ? concepts.add('basic') : null;
          daily.value ? concepts.add('daily') : null;
          simple.value ? concepts.add('simple') : null;
          sik.value ? concepts.add('sik') : null;
          street.value ? concepts.add('street') : null;
          romantic.value ? concepts.add('romantic') : null;
          unique.value ? concepts.add('unique') : null;
          sexy.value ? concepts.add('sexy') : null;
          vintage.value ? concepts.add('vintage') : null;
          widget.model.setConcepts(concepts);
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
          if (!(basic.value ||
              daily.value ||
              simple.value ||
              sik.value ||
              street.value ||
              romantic.value ||
              unique.value ||
              vintage.value ||
              sexy.value)) all.value = true;
          List<String> concepts = new List();
          all.value ? concepts.add('all') : null;
          basic.value ? concepts.add('basic') : null;
          daily.value ? concepts.add('daily') : null;
          simple.value ? concepts.add('simple') : null;
          sik.value ? concepts.add('sik') : null;
          street.value ? concepts.add('street') : null;
          romantic.value ? concepts.add('romantic') : null;
          unique.value ? concepts.add('unique') : null;
          sexy.value ? concepts.add('sexy') : null;
          vintage.value ? concepts.add('vintage') : null;
          widget.model.setConcepts(concepts);
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
    all = BoolWrapper(widget.model.filter.concepts.contains('all'));
    basic = BoolWrapper(widget.model.filter.concepts.contains('basic'));
    daily = BoolWrapper(widget.model.filter.concepts.contains('daily'));
    simple = BoolWrapper(widget.model.filter.concepts.contains('simple'));
    sik = BoolWrapper(widget.model.filter.concepts.contains('sik'));
    street = BoolWrapper(widget.model.filter.concepts.contains('street'));
    romantic = BoolWrapper(widget.model.filter.concepts.contains('romantic'));
    unique = BoolWrapper(widget.model.filter.concepts.contains('unique'));
    sexy = BoolWrapper(widget.model.filter.concepts.contains('sexy'));
    vintage = BoolWrapper(widget.model.filter.concepts.contains('vintage'));
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: Text(
          //     '컨셉',
          //     style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black26),
          //   ),
          // ),
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
