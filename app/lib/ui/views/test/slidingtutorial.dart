import 'package:app/core/services/authentication_service.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/views/swipe/tutorial.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:app/ui/views/test/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class SlidingTutorial extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final int pageCount;

  const SlidingTutorial(
      {Key key, @required this.notifier, @required this.pageCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlidingTutorial();
}

class _SlidingTutorial extends State<SlidingTutorial> {
  var _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _pageController..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.notifier?.value);
    return Stack(children: [
      AnimatedBackgroundColor(
          pageController: _pageController,
          pageCount: widget.pageCount,
          child: Container(
              child: PageView(
                  controller: _pageController,
                  children: List<Widget>.generate(widget.pageCount,
                      (index) => WebAnalyticsPage(index, widget.notifier))))),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    Provider.of<AuthenticationService>(context, listen: false)
                        .storage
                        .write(key: 'image_tutorial', value: 'true');
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'SKIP',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: widget.notifier?.value >= 4
                      ? InkWell(
                          onTap: () async {
                            Provider.of<AuthenticationService>(context,
                                    listen: false)
                                .storage
                                .write(key: 'image_tutorial', value: 'true');

                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '시작하기',
                              style: TextStyle(
                                color: Color(0xFF8569EF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              // widget.notifier?.value = _pageController.page + 1;
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'NEXT',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ))
    ]);
  }

  _onScroll() {
    setState(() {
      widget.notifier?.value = _pageController.page;
    });
  }
}
