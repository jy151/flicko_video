import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

Future showImageStyleDialog({
  required BuildContext context,
  List<ImageStyleGroup> list = const [],
  required int initGroupIndex,
  required Function(int imageGroupIndex,int imageStyleIndex) onSelect
}) async {
  return showBottomSheet(
    context: context,
    builder: (context) => ImageStyleDialog(list: list,onSelect: onSelect,),
  );
}

class ImageStyleDialog extends StatefulWidget {
  List<ImageStyleGroup> list;
  int selectIndex;
  int initGroupIndex;
  Function(int imageGroupIndex,int imageStyleIndex) onSelect;
  ImageStyleDialog({Key? key, this.initGroupIndex = 0,this.list = const [], this.selectIndex = 0, required this.onSelect})
    : super(key: key);

  @override
  _ImageStyleDialogState createState() => _ImageStyleDialogState();
}

class _ImageStyleDialogState extends State<ImageStyleDialog> {
  late List<ImageStyle> imageStyles;
  late int imageStyleGroupIndex;
  @override
  void initState() {
    imageStyleGroupIndex = widget.initGroupIndex;
    imageStyles = widget.list[widget.selectIndex].styles ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xff0d0d1a)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Select Style",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: widget.list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = widget.list[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        imageStyles = item.styles ?? [];
                        imageStyleGroupIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: index == widget.selectIndex
                            ? Color(0xff6c63ff)
                            : Color(0xff1a1a2e),
                      ),
                      child: Center(
                        child: Text(
                          item.title ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16,),
            
            Expanded(
              child: CustomScrollView(
                  slivers: [
                    SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childCount: imageStyles.length,
                      itemBuilder: (context, index) {
                        final item = imageStyles[index];
                        return GestureDetector(
                          onTap: () {
                            widget.onSelect(imageStyleGroupIndex,index);
                            context.pop();
                          },
                          child: Column(children: [
                            Stack(
                              children: [
                                AppNetworkImage(imageUrl:item.cover ?? "",borderRadius: BorderRadius.circular(16), ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 32,
                                    padding: .only(left: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: AlignmentGeometry.bottomCenter,
                                        end: .topCenter,
                                        colors: [
                                        Colors.black.withOpacity(0.1),
                                        Colors.black.withOpacity(0.4)
                                      ])
                                    ),
                                    child: Align(
                                      alignment: .centerLeft,
                                      child: Text(item.title ?? '',style: TextStyle(color: Colors.white),)),
                                  ),
                                  
                                  )
                              ],
                            )
                          ],),
                        );
                      },
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
