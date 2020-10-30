import 'package:app/core/viewmodels/views/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:flutter/material.dart';

class PriceFilter extends StatefulWidget {
  SwipeModel model;
  PriceFilter(this.model);
  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  @override
  Widget build(BuildContext context) {
    RangeValues _values = RangeValues(
        widget.model.filter.start_price.toDouble(),
        widget.model.filter.end_price.toDouble());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '가격',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          _values.end.toInt() == 60000
              ? Text(
                  '${priceText(_values.start.toInt())}원 ~ ${priceText(_values.end.toInt())}원 +',
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              : Text(
                  '${priceText(_values.start.toInt())}원 ~ ${priceText(_values.end.toInt())}원',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
        ]),
        SizedBox(
          height: 16,
        ),
        RangeSlider(
            min: 1,
            max: 60000,
            divisions: 60,
            inactiveColor: Color(0xFFF4F4FC),
            activeColor: Color(0xFF8569EF),
            values: _values,
            onChangeEnd: (values) {
              widget.model.setPrice(values.start.toInt(), values.end.toInt());
            },
            onChanged: (values) {
              setState(() {
                widget.model.setPrice(values.start.toInt(), values.end.toInt());
                // _values = values;
              });
            })
      ],
    );
  }
}
