import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/model/placed_tile.dart';
import 'package:level_editor/model/selected_tile.dart';
import 'package:level_editor/widgets/dotted_outline.dart';
import 'package:level_editor/widgets/tile_place_bar.dart';
import 'package:level_editor/widgets/toolbar.dart';

class LevelEditor extends ConsumerWidget {
  const LevelEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Offset scrollDelta = ref.watch(scrollDeltaProvider);
    Offset mousePosition = ref.watch(mousePositionProvider);
    bool editLevel = ref.watch(editLevelProvider);
    SelectedTile selectedTile = ref.watch(selectedTileProvider);
    List<PlacedTile> placedTiles = ref.watch(placedTilesProvider);
    double cellSize = ref.watch(cellSizeProvider);

    return Scaffold(
      body: Stack(
        children: [
          MouseRegion(
            onHover: (event) {
              if (editLevel) {
                ref.read(mousePositionProvider.notifier).state = event.position;
              }
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerMove: (event) {
                ref.read(scrollDeltaProvider.notifier).state -= event.delta;
              },
              onPointerDown: (event) {
                if (selectedTile.file.path == "" || !editLevel) {
                  return;
                }

                // Get tile position on grid layout
                double x = (mousePosition.dx + scrollDelta.dx) -
                    ((mousePosition.dx + scrollDelta.dx) % cellSize);
                double y = (mousePosition.dy + scrollDelta.dy) -
                    ((mousePosition.dy + scrollDelta.dy) % cellSize);

                // Convert tile position, to simple layout
                x = x / cellSize;
                y = y / cellSize;

                ref.read(placedTilesProvider.notifier).state = [
                  ...placedTiles,
                  PlacedTile(
                    position: Offset(
                      x,
                      y,
                    ),
                    size: Size(
                      selectedTile.size.width,
                      selectedTile.size.height,
                    ),
                    file: selectedTile.file,
                    flags: [],
                  ),
                ];
              },
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (event.scrollDelta.dy < 0) {
                    ref.read(cellSizeProvider.notifier).state += 0.5;
                  }
                  if (event.scrollDelta.dy > 0) {
                    ref.read(cellSizeProvider.notifier).state -= 0.5;
                  }
                }
              },
              child: Stack(
                children: [
                  ...placedTiles
                      .map((tile) => Positioned(
                            top: (tile.position.dy * cellSize) - scrollDelta.dy,
                            left:
                                (tile.position.dx * cellSize) - scrollDelta.dx,
                            child: SizedBox(
                              width: cellSize,
                              height: cellSize,
                              child: Image.file(tile.file),
                            ),
                          ))
                      .toList(),
                  if (editLevel)
                    Positioned(
                      top: mousePosition.dy -
                          ((mousePosition.dy + scrollDelta.dy) % cellSize),
                      left: mousePosition.dx -
                          ((mousePosition.dx + scrollDelta.dx) % cellSize),
                      child: DottedOutline(
                        strokeThickness: 3,
                        lineWidth: 4,
                        spaceBetween: 7,
                        child: SizedBox(
                          width: selectedTile.size.width * cellSize,
                          height: selectedTile.size.height * cellSize,
                          child: selectedTile.file.path != ""
                              ? Image.file(selectedTile.file)
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          //? UI
          const LevelEditorToolbar(),
          const TilePlaceBar(),
        ],
      ),
    );
  }
}
