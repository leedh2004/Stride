import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/dressroom/view.dart';
import 'package:app/ui/views/lookbook/view.dart';
import 'package:flutter/material.dart';

class CollectionView extends StatefulWidget {
  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  var page = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    page = 0;
                  });
                },
                child: Text('드레스룸',
                    style: page == 0 ? currentStyle : notCurrentStyle),
              ),
              Container(
                height: 20,
                child: VerticalDivider(
                  color: Colors.black26,
                  thickness: 3,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    page = 1;
                  });
                },
                child: Text('룩북',
                    style: page == 1 ? currentStyle : notCurrentStyle),
              )
            ],
          ),
          page == 0 ? DressRoomView() : LookBookView()
        ],
      ),
    );
  }
}

const currentStyle = TextStyle(
    color: backgroundColor, fontSize: 20, fontWeight: FontWeight.w700);
const notCurrentStyle =
    TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700);
