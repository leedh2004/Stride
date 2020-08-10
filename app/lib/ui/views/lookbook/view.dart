import 'package:app/core/viewmodels/views/look_book.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:app/ui/widgets/lookbook/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_widget.dart';

class LookBookView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LookBookModel>(
      model: LookBookModel(api: Provider.of(context)),
      onModelReady: (model) {
        model.fetchItems();
      },
      builder: (context, model, child) {
        Widget showWidget;
        if (model.busy) {
          showWidget = LoadingWidget();
        } else {
          showWidget = Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                padding: EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  print("$index 전달");
                  return LookBookItem(item: model.items[index], index: index);
                },
                itemCount: model.items.length,
              ),
            ),
          );
        }
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: showWidget,
        );
      },
    );
  }
}
