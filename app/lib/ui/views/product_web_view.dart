import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductWebView extends StatelessWidget {
  final String mall;
  final String url;
  ProductWebView(this.url, this.mall);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: Image.asset(
              'assets/stride_text_logo.png',
              width: 50,
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          mall,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
