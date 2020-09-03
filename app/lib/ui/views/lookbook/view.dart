import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/lookbook.dart';
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
      model:
          LookBookModel(Provider.of<LookBookService>(context, listen: false)),
      builder: (context, model, child) {
        Widget showWidget;
        if (model.service.init == false) {
          showWidget = LoadingWidget();
          model.getLookBook();
        } else {
          print("???");
          showWidget = Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                padding: EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  print("$index 전달");
                  return LookBookItem(
                      item: model.service.items[index], index: index);
                },
                itemCount: model.service.items.length,
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
