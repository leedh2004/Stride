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
  BoolWrapper chic;
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
            basic.value = daily.value = simple.value = chic.value =
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
          chic.value ? concepts.add('chic') : null;
          street.value ? concepts.add('street') : null;
          romantic.value ? concepts.add('romantic') : null;
          unique.value ? concepts.add('unique') : null;
          sexy.value ? concepts.add('sexy') : null;
          vintage.value ? concepts.add('vintage') : null;
          widget.model.setConcepts(concepts);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(right: 8, bottom: 8),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFFAF9FC),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: Color(0xFF616576)),
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
              chic.value ||
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
          chic.value ? concepts.add('chic') : null;
          street.value ? concepts.add('street') : null;
          romantic.value ? concepts.add('romantic') : null;
          unique.value ? concepts.add('unique') : null;
          sexy.value ? concepts.add('sexy') : null;
          vintage.value ? concepts.add('vintage') : null;
          widget.model.setConcepts(concepts);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(right: 8, bottom: 8),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(242, 240, 253, 1),
              border: Border.all(color: Color(0xFF8569EF))),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Color(0xFF8569EF), fontWeight: FontWeight.w700),
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
    chic = BoolWrapper(widget.model.filter.concepts.contains('chic'));
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
      '시크': chic,
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
          Row(
              children: List.generate(
                  keys.sublist(6, 9).length,
                  (index) => values[index + 6].value
                      ? selectedWidget(keys[index + 6], values[index + 6])
                      : unSelectedWidget(keys[index + 6], values[index + 6]))),
          Row(
            children: [
              vintage.value
                  ? selectedWidget('빈티지', vintage)
                  : unSelectedWidget('빈티지', vintage),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
        ]);
  }
}
