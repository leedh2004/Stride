import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

myPageListTile(String title, Function onTap, Color color) => ListTile(
    contentPadding: EdgeInsets.only(left: 50),
    title: Row(children: [
      Padding(
        padding: EdgeInsets.only(right: 30),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: color),
        ),
      ),
      Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    ]),
    onTap: onTap);
