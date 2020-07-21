import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LookBookView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: WebView(
          initialUrl: 'https://www.naver.com',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
