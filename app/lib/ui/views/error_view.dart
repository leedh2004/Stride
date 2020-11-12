import 'package:app/core/services/error.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/error.png',
                width: 150,
              ),
              SizedBox(
                height: 13,
              ),
              Text("일시적인 오류입니다",
                  style: TextStyle(
                      color: Color(0xFF616576),
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
              SizedBox(
                height: 15,
              ),
              Text("네트워크 상태를 점검해주세요.",
                  style: TextStyle(color: Color(0xFF888C93), fontSize: 12)),
              Text("새로고침을 눌러 앱을 재실행할 수 있습니다.",
                  style: TextStyle(color: Color(0xFF888C93), fontSize: 12)),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Provider.of<ErrorService>(context, listen: false)
                      .errorCreate(null);
                },
                child: Container(
                  width: 225,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Color(0xFF2B3341),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '새로고침',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpaceMedium,
              Text(
                '오류가 지속된다면, help.stride@gmail.com 으로 문의 주세요.',
                style: TextStyle(fontSize: 10, color: Color(0xFF2B3341)),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        )
      ]),
    ));
  }
}
