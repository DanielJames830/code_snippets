import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:valet/presentation/tiled_grid/tile.dart';

class ReorderableStaggeredGrid extends HookWidget {
  final Map<TileData, Widget> mappedChildren;
  final List<Widget> ghosts;
  final int crossAxisCount;
  final ScrollPhysics physics;

  final void Function(List<TileData>)? onReorder;

  ReorderableStaggeredGrid({
    required this.mappedChildren,
    this.crossAxisCount = 2,
    this.physics = const NeverScrollableScrollPhysics(),
    this.ghosts = const [],
    this.onReorder,
  }) : super(key: ValueKey(mappedChildren.mapToIterable((key, value) => '${key.value.id}').join(',')));

  @override
  Widget build(BuildContext context) {
    final reorderedData = useState<List<TileData>>(mappedChildren.keys.toList());

    final movedTile = useState<TileData?>(null);

    final isMounted = useIsMounted();

    List<Widget> tiles = [
      ...reorderedData.value.map(
        (tileData) => Tile(
          tileData: tileData,
          child: mappedChildren[tileData]!,
          draggable: tileData.draggable,
          onNest: (data) {
            movedTile.value = null;
            onReorder?.call(reorderedData.value);
          },
          onEnter: (draggedTileData) {
            final newReorderedData = reorderedData.value.copy();

            newReorderedData.insert(
              newReorderedData.indexOf(tileData),
              newReorderedData.removeAt(
                newReorderedData.indexOf(draggedTileData),
              ),
            );

            if (isMounted()) {
              reorderedData.value = newReorderedData;
            }
          },
          onReorderStart: (draggedTileData) => movedTile.value = draggedTileData,
          onReorderEnd: () {
            movedTile.value = null;
            onReorder?.call(reorderedData.value);
          },
          onReorderCanceled: () {
            movedTile.value = null;
            onReorder?.call(reorderedData.value);
          },
          onReorderCompleted: () {
            movedTile.value = null;
          },
        ),
      ),
      ...ghosts.map(
        (ghost) => Opacity(
          opacity: 0.5,
          child: ghost,
        ),
      ),
    ];

    return tiles.length > 0
        ? MasonryGridView.count(
            key: ObjectKey(reorderedData),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            shrinkWrap: true,
            physics: physics,
            itemCount: tiles.length,
            crossAxisCount: crossAxisCount,
            itemBuilder: (context, index) {
              int duration = 500;
              if (tiles[index] is Tile && movedTile.value == (tiles[index] as Tile).tileData) {
                duration = 0;
              }

              return AnimatedSwitcher(
                duration: Duration(milliseconds: duration),
                child: movedTile.value != null && movedTile.value == (tiles[index] as Tile).tileData
                    ? Opacity(
                        opacity: 0.5,
                        child: tiles[index],
                      )
                    : tiles[index],
                transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
          )
        : Container(
            width: 1,
            height: 1,
          );
  }
}
