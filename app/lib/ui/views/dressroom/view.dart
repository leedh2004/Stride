import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/recent_item.dart';
import 'package:app/core/viewmodels/views/dress_room.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/dressroom/bar_button.dart';
import 'package:app/ui/widgets/dressroom/folder_text_button.dart';
import 'package:app/ui/widgets/dressroom/item.dart';
import 'package:app/ui/widgets/dressroom/no_item_view.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DressRoomFolderView extends StatelessWidget {
  DressRoomModel model;
  DressRoomFolderView(this.model);

  @override
  Widget build(BuildContext context) {
    print('DRESSROOM_FOLDER_VIEW');
    if (model.busy) {
      return LoadingWidget();
    } else {
      if (Provider.of<DressRoomService>(context).items[0] == null) {
        model.getDressRoom();
        return LoadingWidget();
      } else {
        var folder = Provider.of<DressRoomService>(context).folder;
        var folderKeys = folder.keys.toList();
        var folderNames = folder.values.toList();
        return Stack(children: [
          Container(
              child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  children: List.generate(folderNames.length, (index) {
                    var items = Provider.of<DressRoomService>(context)
                        .items[folderKeys[index]];
                    if (folderKeys[index] == 0) folderNames[index] = "내가 찜한 옷";
                    return FolderTextButton(
                        model, folderNames[index], folderKeys[index], items);
                  }))),
        ]);
      }
      // return showWidget;
    }
  }
}
// if (items.length > 0)
//   BaseWidget<RecentItemModel>(
//       model: RecentItemModel(
//           Provider.of(context, listen: false),
//           Provider.of(context, listen: false)),
//       builder: (context, recentmodel, child) {
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(8),
//             child: GridView.builder(
//               shrinkWrap: true,
//               gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: 0.6,
//                 mainAxisSpacing: 10.0,
//                 crossAxisSpacing: 8.0,
//               ),
//               padding: EdgeInsets.all(8),
//               itemBuilder: (context, index) {
//                 double opacity = 0;
//                 if (model.selectedIdx.contains(index))
//                   opacity = 1;
//                 return DressRoomItemWidget(items[index],
//                     opacity, index, recentmodel);
//               },
//               itemCount: items.length,
//             ),
//           ),
//         );
//       }),
// if (items.length == 0) NoItemView(),
// DressRoomButtonBar(model)
