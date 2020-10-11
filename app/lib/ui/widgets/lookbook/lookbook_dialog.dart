import 'package:app/core/models/coordinate.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/views/collection/view.dart';
import 'package:app/ui/views/recent_info.dart';
import 'package:app/ui/widgets/lookbook/lookbook_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LookBookDialog extends StatefulWidget {
  final Coordinate item;
  LookBookDialog(this.item);
  @override
  _LookBookDialogState createState() => _LookBookDialogState();
}

class _LookBookDialogState extends State<LookBookDialog> {
  int page = 0;

  get currentStyle => null;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RecentItemModel>(
        model: RecentItemModel(Provider.of(context, listen: false)),
        builder: (context, model, child) {
          return LookBookInfo(widget.item, model);
        });
  }
}
