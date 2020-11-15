import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:app/ui/views/test/tutorial_image.dart';
import 'package:app/ui/widgets/swipe/card_gesture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

const int WAIT_SWIPE = 1;
const int WAIT_SWIPE_BUTTON = 2;
const int WAIT_COLLECTION_BUTTON = 3;
const int WAIT_INFO_BUTTON = 4;
const int WAIT_PHASE2 = 5;
const int WAIT_BUY_BUTTON = 6;
const int WAIT_PHASE3 = 7;
const int WAIT_FILTER_BUTTON = 8;
const int TUTORIAL_END = 9;

class TutorialWrapper extends StatefulWidget {
  @override
  _TutorialWrapperState createState() => _TutorialWrapperState();
}

class _TutorialWrapperState extends State<TutorialWrapper> {
  bool alreadyShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void tutorialRestart() async {
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    authService.flush_tutorial = 0;
    setState(() {});
    showTutorial(context);
    // await tutorial_restart_flush.show(context).then((value) {
    //   if (value) {
    //   }
    // });
  }

  void showTutorial(BuildContext context) async {
    Stride.logEvent(name: "TUTORIAL_START");
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);
    await flushList[0].show(context);
    await tutorial_start_really.show(context).then((value) {
      if (value == null || value == false) {
        authService.flush_tutorial = -1;
        authService.storage.write(key: 'flush_tutorial', value: 'true');
        flushList2[6].show(context);
      }
    });
    if (authService.flush_tutorial == -1) return;

    await tutorial_start.show(context);
    authService.flush_tutorial = WAIT_SWIPE;
    await flushList[1].show(context).then((result) async {
      if (result == null) {
        authService.flush_tutorial = -1;
        await ban_tutorial_move.show(context);
      } else if (result) {
        await flushList[2].show(context);
      } else {
        await flushList[3].show(context);
      }
    });
    await flushList[7].show(context);
    authService.flush_tutorial = WAIT_SWIPE_BUTTON;
    await flushList[4].show(context).then((result) async {
      if (result == null) {
        authService.flush_tutorial = -1;
        await ban_tutorial_move.show(context);
      } else if (result) {
        await flushList[5].show(context);
      } else {
        await flushList[6].show(context);
      }
    });
    authService.flush_tutorial = WAIT_COLLECTION_BUTTON;
    await flushList[8].show(context).then((value) async {
      if (value != null) {
        // await ban_tutorial_move.show(context);
        await Future.delayed(Duration(seconds: 2));
      }
      authService.flush_tutorial = WAIT_INFO_BUTTON;
      await flushList[9].show(context).then((result) async {
        if (result == null) {
          authService.flush_tutorial = -1;

          await ban_tutorial_end.show(context);
        } else {
          await flushList[10].show(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var configService = Provider.of<ConfigService>(context, listen: false);
    var authService =
        Provider.of<AuthenticationService>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (alreadyShow) return false;
      alreadyShow = true;

      if (!authService.image_tutorial) {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ExamplePage();
        }));
        authService.image_tutorial = true;
      }
      if ((configService.currentVersion != configService.updateVersion) &&
          !configService.alreadyShow) {
        new_version_flush.show(context);
        configService.alreadyShow = true;
      }
      if (authService.flush_tutorial == 0) {
        showTutorial(context);
      }
    });

    return SwipeView(() => tutorialRestart());
  }
}
