import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/core/viewmodels/widgets/dress_room_model.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:frontend/ui/shared/ui_helper.dart';
import 'package:frontend/ui/views/base_widget.dart';
import 'package:frontend/ui/views/product_web_view.dart';
import 'package:frontend/ui/widgets/dress_room_button_bar.dart';
import 'package:provider/provider.dart';

class DressRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<DressRoomModel>(
      model: DressRoomModel(api: Provider.of(context)),
      onModelReady: (model) {
        model.fetchItems();
      },
      builder: (context, model, child) {
        // return CircularProgressIndicator();
        return model.busy
            ? CircularProgressIndicator()
            : Column(children: <Widget>[
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
                        print(model.items[index].product_id);
                        return DressRoomItemWidget(model.items[index],
                            model.items[index].selected.toDouble(), index);
                      },
                      itemCount: model.items.length,
                    ),
                  ),
                ),
                DressRoomButtonBar(model)
              ]);
      },
    );
  }
}

class DressRoomItemWidget extends StatelessWidget {
  final int index;
  final Product item;
  final double opacity;
  DressRoomItemWidget(this.item, this.opacity, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black45, width: 0.5)),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
                aspectRatio: 18 / 17,
                child: Image.network(
                  item.thumbnail_url,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.product_name,
                              style: subHeaderStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('Price ${item.price}')
                          ],
                        ),
                      ),
                      UIHelper.horizontalSpaceMediumLarge
                    ]),
              ),
            )
          ],
        ),
        InkWell(
          onTap: () {
            Provider.of<DressRoomModel>(context, listen: false)
                .selectItem(index);
          },
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  border: Border.all(color: backgroundColor, width: 5)),
            ),
          ),
        ),
        Opacity(
          opacity: 1 - opacity / 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 18,
              icon: FaIcon(FontAwesomeIcons.gift),
              color: backgroundColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductWebView(item.product_url)));
              },
            ),
          ),
        ),
      ]),
    );
  }
}
