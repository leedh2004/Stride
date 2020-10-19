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
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(mall),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(Icons.share),
        //       onPressed: () {
        //         print("공유하기 클릭");
        //       })
        // ],
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
