import 'package:app/ui/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/dot_animation_enum.dart';

class TutorialView extends StatefulWidget {
  @override
  _TutorialViewState createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  List<Slide> slides = new List();
  Function goToTab;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(new Slide(
      title: "반갑습니다!",
      styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'),
      description:
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.",
      styleDescription: TextStyle(
          color: Color(0xfffe9c8f),
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway'),
    ));
    slides.add(new Slide(
      title: "SCHOOL",
      styleTitle: TextStyle(
          color: Color(0xff3da4ab),
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono'),
      description:
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.",
      styleDescription: TextStyle(
          color: Color(0xfffe9c8f),
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway'),
    ));
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: headerStyle, //currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: IntroSlider(
        // List slides
        slides: this.slides,

        // Skip button
        renderSkipBtn: this.renderSkipBtn(),
        colorSkipBtn: Color(0x33ffcc5c),
        highlightColorSkipBtn: Color(0xffffcc5c),

        // Next button
        renderNextBtn: this.renderNextBtn(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),
        onDonePress: this.onDonePress,
        colorDoneBtn: Color(0x33ffcc5c),
        highlightColorDoneBtn: Color(0xffffcc5c),

        // Dot indicator
        colorDot: Color(0xffffcc5c),
        sizeDot: 13.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: this.renderListCustomTabs(),
        backgroundColorAllSlides: Colors.white,
        refFuncGoToTab: (refFunc) {
          this.goToTab = refFunc;
        },

        // Show or hide status bar
        shouldHideStatusBar: true,

        // On tab change completed
        onTabChangeCompleted: this.onTabChangeCompleted,
      )),
    );
  }
}
