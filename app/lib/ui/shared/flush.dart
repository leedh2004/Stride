import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar collection_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  isDismissible: false,
  borderRadius: 8,
  message: '  해당 상품이 콜렉션에 추가되었습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  icon: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Image.asset('assets/purple_star.png', width: 26)),
);

Flushbar tutorial_restart_flush = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  isDismissible: false,
  borderRadius: 8,
  message: '튜토리얼을 다시 진행하시겠어요?',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  mainButton: FlatButton(
    onPressed: () {
      tutorial_restart_flush.dismiss(true); // result = true
    },
    child: Text(
      "다시 진행하기",
      style: TextStyle(color: Colors.amber),
    ),
  ),
);

Flushbar help_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: 'help.stride@gmail.com 으로 문의 부탁드립니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar new_version_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: 'Stride앱의 최신 버전이 나왔습니다!',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar filter_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: '필터가 적용되었습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

List<Flushbar> flushList = [
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    message: '  Stride에 오신걸 환영합니다!',
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
    icon: Padding(
        padding: EdgeInsets.only(left: 12),
        child: Image.asset('assets/stride_logo.png', width: 26)),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    titleText: Text(
      '가볍게 좌/우로 스와이프 해보세요!',
      style: TextStyle(color: Colors.white),
    ),
    messageText: Text(
      "카드를 왼쪽으로 스와이프하면 '별로예요', 오른쪽으로 스와이프하면 '좋아요'",
      style: TextStyle(color: Colors.white, fontSize: 11),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '아이템이 마음에 드시는군요!\n이런 느낌으로 추천해드릴게요!',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    icon: Padding(
        padding: EdgeInsets.only(top: 12, left: 8),
        child: Image.asset('assets/heart_button_s.png', width: 26)),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '아이템이 마음에 안 드시는군요!\n다른 아이템으로 보여드릴게요!',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    icon: Padding(
        padding: EdgeInsets.only(top: 12, left: 8),
        child: Image.asset('assets/dislike_button_s.png', width: 26)),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Text(
      "버튼으로도 '좋아요', '별로에요'를 하실 수 있어요.\n하단에 있는 버튼을 탭해보세요!",
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '아이템이 마음에 드시는군요!\n이런 느낌으로 추천해드릴게요!',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    icon: Padding(
        padding: EdgeInsets.only(top: 12, left: 8),
        child: Image.asset('assets/heart_button_s.png', width: 26)),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '아이템이 마음에 안 드시는군요!\n다른 아이템으로 보여드릴게요!',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    icon: Padding(
        padding: EdgeInsets.only(top: 12, left: 8),
        child: Image.asset('assets/dislike_button_s.png', width: 26)),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 4000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '실시간으로 데이터를 분석해, 스와이프 할수록 취향에 맞는 상품만 보여드릴게요!',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 3000),
    margin: EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: false,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('정말 사고 싶은 옷을 발견했다면?\n',
          style: TextStyle(color: Colors.white, fontSize: 14)),
      Row(children: [
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Image.asset(
            'assets/purple_star.png',
            width: 20,
          ),
        ),
        Text('을 눌러 아이템을 저장할 수 있어요!',
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('카드에 있는 아이템의 이름을 탭하면 아이템을 자세히 관찰할 수 있어요! 한 번 탭해보시겠어요?',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 3000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('좋아요! 이 곳에서 사이즈 정보, 색상 등의 정보를 확인하실 수 있습니다!',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
];

List<Flushbar> flushList2 = [
  Flushbar(
    duration: Duration(milliseconds: 3500),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('상품을 구매하고 싶다면?\n',
          style: TextStyle(color: Colors.white, fontSize: 14)),
      Wrap(children: [
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Image.asset(
            'assets/shopping-bag.png',
            width: 18,
            height: 18,
          ),
        ),
        Text('을 눌러 구매 페이지로 이동할 수 있어요.',
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '카드의 오른쪽 부분을 탭하면 같은 아이템의 다른 이미지를 보실 수 있어요! 한 번 탭해보시겠어요?',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '좋아요, 이번에는 카드의 왼쪽 부분을 탭해보시겠어요?',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    titleText: Text(
      '내가 찾고싶은 아이템이 보이지 않는다면?',
      style: TextStyle(color: Colors.white),
    ),
    messageText: Text(
      '한 번 우측 상단에 필터설정 버튼을 탭 해보세요!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 3000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '원하는 카테고리, 컨셉, 사이즈, 가격, 컬러에 맞춘 아이템을 필터로 검색해보세요!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 2000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      '튜토리얼을 진행해주셔서 감사합니다!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 4000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: Text(
      "화면 상단의 '?' 버튼을 클릭하면 다시 튜토리얼로 돌아와, 스트라이드의 다양한 기능을 알아보실 수 있습니다!",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
];
