import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/main.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/dressroom/bar_button.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DressRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Consumer를 없앴음, StreamProvider도 없애버림
    return BaseWidget<DressRoomModel>(
        model: DressRoomModel(Provider.of<DressRoomService>(context)),
        builder: (context, model, child) {
          Widget showWidget;
          if (model.busy) {
            showWidget = LoadingWidget();
          } else {
            if (Provider.of<DressRoomService>(context)
                    .items[model.current_folder] ==
                null) {
              model.getDressRoom();
              showWidget = LoadingWidget();
            } else {
              var items = Provider.of<DressRoomService>(context)
                  .items[model.current_folder];
              var folder = Provider.of<DressRoomService>(context).folder;
              var folderKeys = folder.keys.toList();
              var folderNames = folder.values.toList();
              print(folder);
              showWidget = Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(folderNames.length, (index) {
                      var folderName = folderNames[index];
                      if (folderName == 'default') folderName = '♥';
                      return folderKeys[index] != model.current_folder
                          ? InkWell(
                              onTap: () {
                                model.changeFolder(folderKeys[index]);
                                Stride.analytics
                                    .logEvent(name: "DRESS_ROOM_FOLDER_CHANGE");
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  constraints: BoxConstraints(minWidth: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: Center(child: Text('${folderName}'))))
                          : InkWell(
                              onTap: () {
                                model.changeFolder(folderKeys[index]);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  constraints: BoxConstraints(minWidth: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black),
                                  child: Center(
                                      child: Text(
                                    '${folderName}',
                                    style: whiteStyle,
                                  ))));
                    }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      //crossAxisCount: 2,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 8.0,
                      ),
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        double opacity = 0;
                        if (model.selectedIdx.contains(index)) opacity = 1;
                        return DressRoomItemWidget(
                            items[index], opacity, index);
                      },
                      itemCount: items.length,
                    ),
                  ),
                ),
                DressRoomButtonBar(model)
              ]);
            }
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: showWidget,
            );
          }
        });
  }
}
