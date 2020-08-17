import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(4)),
    );
  }
}
