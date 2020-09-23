import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

myPageListTile(FaIcon icon, String title, Function onTap) => ListTile(
    contentPadding: EdgeInsets.only(left: 50),
    leading: icon,
    title: Text(title),
    onTap: onTap);
