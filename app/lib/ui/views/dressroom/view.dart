import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
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
        model: DressRoomModel(
            Provider.of<DressRoomService>(context, listen: false)),
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
              showWidget = Column(children: <Widget>[
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
