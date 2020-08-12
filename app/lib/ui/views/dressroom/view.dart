import 'package:app/core/models/product.dart';
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
    return Consumer<List<Product>>(builder: (context, items, child) {
      if (items == null) {
        return LoadingWidget();
      } else {
        return BaseWidget<DressRoomModel>(
          model: DressRoomModel(items),
          onModelReady: (model) {
            //model.fetchItems();
          },
          builder: (context, model, child) {
            Widget showWidget;
            if (model.busy) {
              showWidget = LoadingWidget();
            } else {
              showWidget = Column(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      //crossAxisCount: 2,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        print(index);
                        //print(items[index].product_id);
                        return DressRoomItemWidget(items[index],
                            model.items[index].selected.toDouble(), index);
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
          },
        );
      }
    });
  }
}
