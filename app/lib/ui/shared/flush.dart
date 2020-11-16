import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';

Flushbar exit = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: "'뒤로'버튼 한번 더 누르시면 종료됩니다.",
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar collection_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: '  해당 상품이 컬렉션에 추가되었습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  icon: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Image.asset('assets/purple_star.png', width: 26)),
);

Flushbar ban_review_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: '죄송합니다. 현재 리뷰 사용이 불가능합니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar lookbook_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: '  룩북에 아이템이 추가되었습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  icon: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Image.asset('assets/purple_star.png', width: 26)),
);

Flushbar tutorial_start = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  borderRadius: 8,
  message: '튜토리얼을 시작할게요.\n튜토리얼 중 특정 기능은 작동하지 않을 수 있습니다!',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_tutorial_end = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 3500),
  borderRadius: 8,
  title: '튜토리얼 종료',
  messageText: RichText(
    text: TextSpan(children: [
      TextSpan(
        text: '화면 상단의 ',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      WidgetSpan(
          child: FaIcon(
        FontAwesomeIcons.questionCircle,
        size: 15,
        color: Colors.white,
      )),
      TextSpan(
        text: ' 버튼을 클릭하면 ',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      TextSpan(
        text: '다시 튜토리얼로 돌아와',
        style: TextStyle(color: Colors.amber, fontSize: 14),
      ),
      TextSpan(
        text: ', 스트라이드의 다양한 기능을 알아보실 수 있습니다!',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ]),
  ),
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_tutorial_move = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  borderRadius: 8,
  message: '튜토리얼 중에 백버튼 사용이 불가능합니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_tutorial_move2 = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 4000),
  borderRadius: 8,
  message: '백 버튼 사용이 불가능합니다.\n상품의 이름을 클릭하지 않으면, 더 이상 앱이 작동하지 않습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_tutorial_move3 = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 4000),
  borderRadius: 8,
  message: '백 버튼 사용이 불가능합니다.\n장바구니를 클릭하지 않으면, 더 이상 앱이 작동하지 않습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_tutorial_move4 = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 4000),
  borderRadius: 8,
  message: '백 버튼 사용이 불가능합니다.\n필터설정을 클릭하지 않으면, 더 이상 앱이 작동하지 않습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_remove = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  borderRadius: 8,
  message: '삭제할 아이템을 클릭하여 선택해주세요.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_move = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  borderRadius: 8,
  message: '폴더를 이동할 아이템을 클릭하여 선택해주세요.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar ban_make = Flushbar(
  margin: EdgeInsets.all(8),
  duration: Duration(milliseconds: 2500),
  borderRadius: 8,
  message: '버튼을 활성화하려면 적어도 하나의 상의와, 하의가 선택되어야 합니다!',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
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

Flushbar tutorial_start_really = Flushbar(
  margin: EdgeInsets.all(8),
  isDismissible: false,
  borderRadius: 8,
  message: '튜토리얼을 통해 스트라이드의 다양한 기능을 자세히 알아보시겠어요?\n1분 정도의 시간이 소요될 수 있습니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  mainButton: Row(children: [
    InkWell(
      onTap: () {
        tutorial_start_really.dismiss(true); // result = true
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "네",
          style: TextStyle(color: Colors.amber),
        ),
      ),
    ),
    SizedBox(
      width: 8,
    ),
    InkWell(
      onTap: () {
        Stride.logEvent(name: 'TUTORIAL_SKIP');
        tutorial_start_really.dismiss(false); // result = true
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "됐어요",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    )
  ]),
);

Flushbar help_flush = Flushbar(
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: 'help.stride@gmail.com 으로 문의 부탁드립니다.',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);

Flushbar nice_flush = Flushbar(
  duration: Duration(milliseconds: 1500),
  margin: EdgeInsets.all(8),
  borderRadius: 8,
  message: '좋아요! 다시 뒤로 가볼까요?',
  backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
);
// Flushbar disable_flush = Flushbar(
//   duration: Duration(milliseconds: 2000),
//   margin: EdgeInsets.all(8),
//   borderRadius: 8,
//   message: '튜토리얼 중에는 불가능한 기능입니다!',
//   backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
// );

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
    messageText: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '카드를 ', style: TextStyle(color: Colors.white, fontSize: 12)),
      TextSpan(text: '왼쪽', style: TextStyle(color: Colors.amber, fontSize: 12)),
      TextSpan(
          text: '으로 스와이프하면',
          style: TextStyle(color: Colors.white, fontSize: 12)),
      TextSpan(
          text: " '별로에요'\n",
          style: TextStyle(color: Colors.amber, fontSize: 12)),
      TextSpan(
          text: '오른쪽', style: TextStyle(color: Colors.amber, fontSize: 12)),
      TextSpan(
          text: '으로 스와이프하면',
          style: TextStyle(color: Colors.white, fontSize: 12)),
      TextSpan(
          text: " '좋아요'", style: TextStyle(color: Colors.amber, fontSize: 12)),
    ])),
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
    messageText: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '버튼으로도 ', style: TextStyle(color: Colors.white, fontSize: 14)),
      WidgetSpan(
          child: Image.asset(
        'assets/heart_button.png',
        width: 15,
      )),
      TextSpan(
          text: "'좋아요', ", style: TextStyle(color: Colors.amber, fontSize: 14)),
      WidgetSpan(
          child: Image.asset(
        'assets/dislike_button.png',
        width: 15,
      )),
      TextSpan(
          text: "'별로에요'", style: TextStyle(color: Colors.amber, fontSize: 14)),
      TextSpan(
          text: '를 하실 수 있어요.\n하단에 있는 버튼을 클릭해보세요!',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ])),
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
    messageText: RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: '실시간으로 데이터를 분석해',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          TextSpan(
              text: ' 스와이프 할수록 취향에 맞는 상품만',
              style: TextStyle(color: Colors.amber, fontSize: 14)),
          TextSpan(
              text: ' 보여드릴게요!',
              style: TextStyle(color: Colors.white, fontSize: 14))
        ],
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: false,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('아이템을 저장', style: TextStyle(color: Colors.amber, fontSize: 14)),
      Text('하고 싶다면?\n', style: TextStyle(color: Colors.white, fontSize: 14)),
      Row(children: [
        Text(
          '한 번 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Image.asset(
            'assets/star_button.png',
            width: 20,
          ),
        ),
        Text(' 버튼을 눌러보시겠어요?',
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '카드에 있는 ', style: TextStyle(color: Colors.white, fontSize: 14)),
      TextSpan(
          text: '아이템의 이름', style: TextStyle(color: Colors.amber, fontSize: 14)),
      WidgetSpan(
          child: FaIcon(
        FontAwesomeIcons.infoCircle,
        color: Colors.amber,
        size: 15,
      )),
      TextSpan(
          text: ' 을 탭하면 아이템을 자세히 관찰할 수 있어요! 한 번 탭해보시겠어요?',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ])),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 3000),
    margin: EdgeInsets.all(8),
    isDismissible: true,
    borderRadius: 8,
    messageText: Wrap(children: [
      Text('좋아요! 이 곳에서 ', style: TextStyle(color: Colors.white, fontSize: 14)),
      Text('사이즈, 색상 ', style: TextStyle(color: Colors.amber, fontSize: 14)),
      Text('등의 정보를 확인하실 수 있습니다!',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
];

List<Flushbar> flushList2 = [
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    titleText: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '상품을 ', style: TextStyle(color: Colors.white, fontSize: 14)),
      TextSpan(
          text: '구매 ', style: TextStyle(color: Colors.amber, fontSize: 14)),
      TextSpan(
          text: '하고 싶으세요?',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ])),
    messageText: Wrap(children: [
      Padding(
        padding: EdgeInsets.only(right: 4),
        child: Image.asset(
          'assets/shopping-bag@2x.png',
          width: 18,
          height: 18,
        ),
      ),
      Text('버튼을 눌러보시겠어요?', style: TextStyle(color: Colors.white, fontSize: 14)),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: RichText(
      text: TextSpan(children: [
        TextSpan(
            text: '카드의 ', style: TextStyle(color: Colors.white, fontSize: 14)),
        TextSpan(
            text: '오른쪽 부분',
            style: TextStyle(color: Colors.amber, fontSize: 14)),
        TextSpan(
            text: '을 탭하면 같은 아이템의 다른 이미지를 보실 수 있어요! 한 번 탭해보시겠어요?',
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '좋아요, 이번에는 카드의 ',
          style: TextStyle(color: Colors.white, fontSize: 14)),
      TextSpan(
          text: '왼쪽 부분을', style: TextStyle(color: Colors.amber, fontSize: 14)),
      TextSpan(
          text: '탭해보시겠어요?',
          style: TextStyle(color: Colors.white, fontSize: 14)),
    ])),
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
    messageText: Wrap(children: [
      Text(
        '한 번 우측 상단에 ',
        style: TextStyle(color: Colors.white),
      ),
      Text(
        '필터설정 버튼',
        style: TextStyle(color: Colors.amber),
      ),
      Text(
        '을 탭 해보세요!',
        style: TextStyle(color: Colors.white),
      ),
    ]),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
  Flushbar(
    duration: Duration(milliseconds: 3000),
    margin: EdgeInsets.all(8),
    isDismissible: false,
    borderRadius: 8,
    messageText: RichText(
        text: TextSpan(children: [
      TextSpan(
        text: '원하는 ',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      TextSpan(
        text: '카테고리, 컨셉, 사이즈, 가격, 컬러',
        style: TextStyle(color: Colors.amber, fontSize: 14),
      ),
      TextSpan(
        text: '에 맞춘 아이템을 필터로 검색해보세요!',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ])),
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
    messageText: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '화면 상단의 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        WidgetSpan(
            child: FaIcon(
          FontAwesomeIcons.questionCircle,
          size: 15,
          color: Colors.amber,
        )),
        TextSpan(
          text: ' 버튼',
          style: TextStyle(color: Colors.amber, fontSize: 14),
        ),
        TextSpan(
          text: '을 클릭하면 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        TextSpan(
          text: '다시 튜토리얼로 돌아와',
          style: TextStyle(color: Colors.amber, fontSize: 14),
        ),
        TextSpan(
          text: ', 스트라이드의 다양한 기능을 알아보실 수 있습니다!',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ]),
    ),
    backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
  ),
];
