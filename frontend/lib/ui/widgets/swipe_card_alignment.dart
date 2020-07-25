import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';

class SwipeCardAlignment extends StatelessWidget {
  final int cardNum;
  SwipeCardAlignment(this.cardNum);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            SizedBox.expand(
              child: AspectRatio(
                aspectRatio: 11 / 16,
                child: Image.network(
                    "http://www.66girls.co.kr/web/product/big/201910/3091a301c1bcb448b04f8ab76761865c.jpg",
                    fit: BoxFit.fitHeight),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.black12,
                  Colors.black26,
                  Colors.black54
                ], stops: [
                  0.1,
                  0.2,
                  0.4,
                  0.9
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '로드리 스커트',
                        style: whiteShadowStyle,
                      ),
                      Text(
                        'Price 17,000',
                        style: whiteSmallShadowStyle,
                      )
                    ]),
              ),
            ),
          ],
        ));
  }
}
