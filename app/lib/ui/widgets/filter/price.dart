import 'package:flutter/material.dart';

class PriceFilter extends StatefulWidget {
  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  RangeValues _values = RangeValues(1, 200000);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '가격대',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black26),
          ),
        ),
        Text(
          '${_values.start.toInt()} ~ ${_values.end.toInt()}원',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: RangeSlider(
              min: 1,
              max: 200000,
              divisions: 200,
              inactiveColor: Colors.black26,
              activeColor: Colors.black,
              values: _values,
              onChanged: (values) {
                setState(() {
                  _values = values;
                });
              }),
        )
      ],
    );
  }
}
