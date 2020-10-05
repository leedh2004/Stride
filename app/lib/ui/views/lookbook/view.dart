import 'package:app/core/services/lookbook.dart';
import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/widgets/dressroom/folder_text_button.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/lookbook/bar_button.dart';
import 'package:app/ui/widgets/lookbook/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';

class LookBookView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LookBookModel>(
      model:
          LookBookModel(Provider.of<LookBookService>(context, listen: false)),
      builder: (context, model, child) {
        Widget showWidget;
        if (model.service.init == false) {
          showWidget = LoadingWidget();
          model.getLookBook();
        } else {
          var items =
              Provider.of<LookBookService>(context).items[model.current_folder];
          var folder = Provider.of<LookBookService>(context).folder;
          var folderKeys = folder.keys.toList();
          var folderNames = folder.values.toList();

          showWidget = Expanded(
            child: Column(children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(folderNames.length, (index) {
                    var folderName = folderNames[index];
                    if (folderName == 'default') folderName = '♥';
                    return FolderTextButton(
                        model,
                        folderName,
                        folderKeys[index],
                        folderKeys[index] != model.current_folder);
                  }),
                ),
              ),
              // Expanded(child: Container(color: Colors.red)),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: items.length > 0
                        ? Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                              ),
                              padding: EdgeInsets.all(5),
                              itemBuilder: (context, index) {
                                double opacity = 0;
                                if (model.selectedIdx.contains(index))
                                  opacity = 1;
                                return LookBookItem(
                                    item: items[index],
                                    opacity: opacity,
                                    index: index);
                              },
                              itemCount: items.length,
                            ),
                          )
                        : Container(
                            child: Align(
                              alignment: Alignment.center + Alignment(0, -0.25),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/fashion.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text("룩북에 아이템이 없어요", style: headerStyle),
                                  UIHelper.verticalSpaceSmall,
                                  Text("좋아하는 상하의를 조합해서",
                                      style: dressRoomsubHeaderStyle),
                                  Text("나만의 룩북을 만들어 보아요",
                                      style: dressRoomsubHeaderStyle),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              LookBookButtonBar(model)
            ]),
          );
        }
        return showWidget;
        // return AnimatedSwitcher(
        //   duration: Duration(milliseconds: 500),
        //   child: showWidget,
        // );
      },
    );
  }
}
