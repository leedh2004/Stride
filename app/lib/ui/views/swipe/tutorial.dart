import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorialWrapper extends StatefulWidget {
  @override
  _TutorialWrapperState createState() => _TutorialWrapperState();
}

class _TutorialWrapperState extends State<TutorialWrapper> {
  void tutorialRestart() async {
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    await tutorial_restart_flush.show(context).then((value) {
      if (value) {
        authService.flush_tutorial = 0;
        setState(() {});
      }
    });
  }

  void showTutorial(BuildContext context) async {
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    // if(authService.flush_tutorial == 0){

    // }else if(authService.f)
    await flushList[0].show(context);
    await flushList[1].show(context).then((result) async {
      if (result) {
        await flushList[2].show(context);
      } else {
        await flushList[3].show(context);
      }
    });
    await flushList[7].show(context);
    await flushList[4].show(context).then((result) async {
      if (result) {
        await flushList[5].show(context);
      } else {
        await flushList[6].show(context);
      }
    });
    await flushList[8].show(context);
    await flushList[9].show(context).then((result) async {
      await flushList[10].show(context);
    });
    authService.flush_tutorial++;
  }

  @override
  Widget build(BuildContext context) {
    var configService = Provider.of<ConfigService>(context, listen: false);
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if ((configService.currentVersion != configService.updateVersion) &&
          !configService.alreadyShow) {
        new_version_flush.show(context);
        configService.alreadyShow = true;
      }
      if (authService.flush_tutorial == 0 && authService.onTutorial == false) {
        showTutorial(context);
        authService.onTutorial = true;
      }
    });

    return SwipeView(() => tutorialRestart());
  }
}
