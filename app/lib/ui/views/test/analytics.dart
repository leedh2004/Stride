import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class WebAnalyticsPage extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;

  WebAnalyticsPage(this.page, this.notifier);

  @override
  Widget build(BuildContext context) {
    return SlidingPage(
      page: page,
      notifier: notifier,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SlidingContainer(
          child: Image.asset(
            "assets/tutorial_${page + 1}.png",
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
