import 'package:app/ui/views/test/slidingtutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class ExamplePage extends StatefulWidget {
  ExamplePage({Key key}) : super(key: key);

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final ValueNotifier<double> notifier = ValueNotifier(0);
  int pageCount = 5;

  @override
  Widget build(BuildContext context) {
    print(notifier.value);
    return Scaffold(
      body: Center(
          child: Stack(
        children: <Widget>[
          SlidingTutorial(
            pageCount: pageCount,
            notifier: notifier,
          ),
        ],
      )),
    );
  }
}
