import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/models/coordinate.dart';
import 'package:frontend/core/services/api.dart';
import 'package:frontend/core/viewmodels/views/login_viewmodel.dart';
import 'package:frontend/core/viewmodels/widgets/look_book_model.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';
import 'package:frontend/ui/views/base_widget.dart';
import 'package:frontend/ui/widgets/delete_alert_dialog.dart';
import 'package:frontend/ui/widgets/look_book_dialog.dart';
import 'package:provider/provider.dart';

class LookBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LookBookModel>(
      model: LookBookModel(api: Provider.of(context)),
      onModelReady: (model) {
        model.fetchItems();
      },
      builder: (context, model, child) {
        return model.busy
            ? CircularProgressIndicator()
            : Padding(
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
              );
      },
    );
  }
}

class LookBookItem extends StatelessWidget {
  final Coordinate item;
  final int index;
  LookBookItem({this.item, this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black45, width: 0.5)),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                showDialog(context: context, child: LookBookDialog(item));
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 200,
                      child: Image.network(
                        item.top_thumbnail_url,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 200,
                      child: Image.network(
                        item.bottom_thumbnail_url,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  UIHelper.horizontalSpaceSmall,
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.name,
                      style: subHeaderStyle,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: 16,
                      color: Colors.black54,
                      icon: FaIcon(FontAwesomeIcons.edit),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              final _textController = TextEditingController();
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                content: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "새로운 이름을 입력해주세요"),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, _textController.text);
                                      },
                                      child: Text('수정')),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('취소'))
                                ],
                              );
                            });
                        if (result != null) {
                          Provider.of<LookBookModel>(context, listen: false)
                              .rename(index, result);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: 16,
                      color: Colors.black54,
                      icon: FaIcon(FontAwesomeIcons.trash),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteAlertDialog();
                            });
                        if (result == "remove") {
                          Provider.of<LookBookModel>(context, listen: false)
                              .removeItem(index);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
