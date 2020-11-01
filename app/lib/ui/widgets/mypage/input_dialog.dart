import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/tutorial.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/widgets/mypage/input_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeInputDialog extends StatefulWidget {
  StrideUser user;
  SizeInputDialog(this.user);
  @override
  _SizeInputDialogState createState() => _SizeInputDialogState();
}

class _SizeInputDialogState extends State<SizeInputDialog> {
  var _shoulderflag = FlagWrapper(false);
  var _breastflag = FlagWrapper(false);
  var _waistflag = FlagWrapper(false);
  var _hipflag = FlagWrapper(false);
  var _thighflag = FlagWrapper(false);
  var _shoulderRange = RangeWrapper(RangeValues(38, 42));
  var _breastRange = RangeWrapper(RangeValues(83, 93));
  var _waistRange = RangeWrapper(RangeValues(25, 29));
  var _hipRange = RangeWrapper(RangeValues(88, 96));
  var _thighRange = RangeWrapper(RangeValues(24, 32));

  @override
  Widget build(BuildContext context) {
    // print(widget.user.shoulder[0]);
    if (widget.user.shoulder != null) {
      _shoulderRange = RangeWrapper(
          RangeValues(widget.user.shoulder[0], widget.user.shoulder[1]));
      _shoulderflag = FlagWrapper(true);
    }
    if (widget.user.bust != null) {
      _breastRange =
          RangeWrapper(RangeValues(widget.user.bust[0], widget.user.bust[1]));
      _breastflag = FlagWrapper(true);
    }
    if (widget.user.hip != null) {
      _hipRange =
          RangeWrapper(RangeValues(widget.user.hip[0], widget.user.hip[1]));
      _hipflag = FlagWrapper(true);
    }
    if (widget.user.thigh != null) {
      _thighRange =
          RangeWrapper(RangeValues(widget.user.thigh[0], widget.user.thigh[1]));
      _thighflag = FlagWrapper(true);
    }
    if (widget.user.waist != null) {
      _waistRange =
          RangeWrapper(RangeValues(widget.user.waist[0], widget.user.waist[1]));
      _waistflag = FlagWrapper(true);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '사이즈 수정',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFF4F4FC)),
                child: Center(
                  child: Text(
                    '잘 모르시는 부분은 체크를 해제 해주세요!',
                    style: TextStyle(color: Color(0xFF8569EF)),
                  ),
                ),
              ),
              InputThirdPage(
                shoulderRange: _shoulderRange,
                shoulderflag: _shoulderflag,
                breastRange: _breastRange,
                breastflag: _breastflag,
                waistRange: _waistRange,
                waistflag: _waistflag,
                hipRange: _hipRange,
                hipflag: _hipflag,
                thighRange: _thighRange,
                thighflag: _thighflag,
              ),
              InkWell(
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFF2B3341)),
                  child: Center(
                    child: Text(
                      '적용하기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                onTap: () async {
                  print(_shoulderRange.value);
                  if (await Provider.of<TutorialService>(context, listen: false)
                      .sendSize([
                    _waistRange,
                    _hipRange,
                    _thighRange,
                    _shoulderRange,
                    _breastRange
                  ], [
                    _waistflag,
                    _hipflag,
                    _thighflag,
                    _shoulderflag,
                    _breastflag
                  ])) {
                    Provider.of<AuthenticationService>(context, listen: false)
                        .changeUserSize([
                      _waistRange,
                      _hipRange,
                      _thighRange,
                      _shoulderRange,
                      _breastRange
                    ], [
                      _waistflag,
                      _hipflag,
                      _thighflag,
                      _shoulderflag,
                      _breastflag
                    ]);
                    // Provider.of<StrideUser>(context, listen: false).profile_flag =
                    //     true;
                    ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 1500),
                      backgroundColor: Color.fromRGBO(63, 70, 82, 0.9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      content: Row(children: [
                        Image.asset('assets/purple_star.png', width: 30),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('사이즈가 수정되었습니다!')),
                      ]),
                    ));
                    Navigator.maybePop(context);
                  }
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
