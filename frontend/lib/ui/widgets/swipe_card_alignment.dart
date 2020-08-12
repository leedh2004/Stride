import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';

class SwipeCardAlignment extends StatelessWidget {
  //final int cardNum;

  final Product item;
  SwipeCardAlignment(this.item);

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
                  child: FancyShimmerImage(
                    imageUrl: item.thumbnail_url,
                    boxFit: BoxFit.cover,
                    errorWidget: Icon(Icons.error),
                    shimmerHighlightColor: backgroundColor,
                    shimmerBackColor: backgroundColor,
                    shimmerBaseColor: backgroundTransparentColor,

                    // placeholder: (context, url) => LoadingWidget(),
                  )),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.product_name, //'로드리 스커트',
                        style: whiteShadowStyle,
                      ),
                      Text(
                        'Price ${item.price}',
                        style: whiteSmallShadowStyle,
                      )
                    ]),
              ),
            ),
          ],
        ));
  }
}
