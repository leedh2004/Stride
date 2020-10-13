import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/dressroom/bar_button.dart';
import 'package:app/ui/widgets/dressroom/folder_text_button.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/dressroom/no_item_view.dart';
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
              showWidget = Expanded(
                child: Column(children: <Widget>[
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
                  if (items.length > 0)
                    BaseWidget<RecentItemModel>(
                        model: RecentItemModel(
                            Provider.of(context, listen: false),
                            Provider.of(context, listen: false)),
                        builder: (context, recentmodel, child) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.6,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 8.0,
                                ),
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  double opacity = 0;
                                  if (model.selectedIdx.contains(index))
                                    opacity = 1;
                                  return DressRoomItemWidget(items[index],
                                      opacity, index, recentmodel);
                                },
                                itemCount: items.length,
                              ),
                            ),
                          );
                        }),
                  if (items.length == 0) NoItemView(),
                  DressRoomButtonBar(model)
                ]),
              );
            }
            return showWidget;
          }
        });
  }
}
