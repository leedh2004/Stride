import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/services/authentication_service.dart';
import 'package:frontend/core/viewmodels/views/login_viewmodel.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [gradientStart, backgroundColor])),
        child: ChangeNotifierProvider<LoginViewModel>.value(
            value: LoginViewModel(
                authenticationService:
                    Provider.of<AuthenticationService>(context, listen: false)),
            child: Consumer<LoginViewModel>(builder: (context, model, child) {
              Widget showWidget;
              if (model.busy) {
                showWidget = LoadingWidget();
              } else {
                showWidget = Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.fire,
                      color: Colors.white,
                      size: 60,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Text('Stride', style: whiteHeaderStyle),
                    UIHelper.verticalSpaceMedium,
                    GoogleSignInButton(
                      onPressed: () {
                        model.handlgeGoogleSignIn();
                      },
                      textStyle: TextStyle(fontSize: 15),
                    ),
                    FacebookSignInButton(
                      onPressed: () async {
                        model.handleFacebookSignIn();
                      },
                      text: "Sign in with Facebook",
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    AppleSignInButton(
                      onPressed: () {},
                      style: AppleButtonStyle.black,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          model.handleWithoutSignIn();
                        },
                        color: Colors.yellowAccent,
                        child: Text('Without Login'))
                  ],
                ));
              }
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: showWidget,
              );
            })),
      ),
    );
  }
}

Widget LoadingWidget() {
  return Center(
    child: Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.fire,
            color: Colors.white,
            size: 48,
          ),
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
              spinnerMode: true,
              customColors: CustomSliderColors(progressBarColors: [
                gradientStart,
                backgroundColor,
              ]),
            ),
          )
        ],
      ),
    ),
  );
}
