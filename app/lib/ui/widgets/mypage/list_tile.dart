import 'package:flutter/material.dart';

myPageListTile(String title, Function onTap, String file) => ListTile(
    contentPadding: EdgeInsets.only(left: 27),
    title: Row(children: [
      Padding(
          padding: EdgeInsets.only(right: 30),
          child: Image.asset(
            file,
            width: 15,
          )),
      Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ]),
    onTap: onTap);
