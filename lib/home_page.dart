import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/model/editing_state.dart';
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
    EditingState editingState = ref.watch(editingModeProvider);
    SelectedTile selectedTile = ref.watch(selectedTileProvider);
    List<PlacedTile> placedTiles = ref.watch(placedTilesProvider);
    double cellSize = ref.watch(cellSizeProvider);

    return Scaffold(
      body: Stack(
        children: [
          MouseRegion(
            onHover: (event) {
              ref.read(mousePositionProvider.notifier).state = event.position;
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerMove: (event) {
                ref.read(scrollDeltaProvider.notifier).state -= event.delta;
              },
              onPointerDown: (event) {
                if (editingState == EditingState.edit) {
                  List<PlacedTile> newTiles = [];

                  for (int column = 0;
                      column < selectedTile.size.width;
                      column++) {
                    for (int row = 0; row < selectedTile.size.height; row++) {
                      double x = ((mousePosition.dx + (column * cellSize)) +
                              scrollDelta.dx) -
                          (((mousePosition.dx + (column * cellSize)) +
                                  scrollDelta.dx) %
                              cellSize);
                      double y = ((mousePosition.dy + (row * cellSize)) +
                              scrollDelta.dy) -
                          (((mousePosition.dy + (row * cellSize)) +
                                  scrollDelta.dy) %
                              cellSize);

                      newTiles.add(
                        PlacedTile(
                          position: Offset(x, y),
                          file: selectedTile.file,
                          flags: selectedTile.flags,
                        ),
                      );
                    }
                  }

                  // Convert tile position, to simple layout
                  List<PlacedTile> newTilesOnSimpleGrid = newTiles
                      .map((tile) => PlacedTile(
                          position: Offset(tile.position.dx / cellSize,
                              tile.position.dy / cellSize),
                          file: tile.file,
                          flags: tile.flags))
                      .toList();
                  if (selectedTile.file.path == "") {
                    return;
                  }

                  ref.read(placedTilesProvider.notifier).state = [
                    ...placedTiles,
                    ...newTilesOnSimpleGrid
                  ];
                }
                if (editingState == EditingState.delete) {
                  double x = (mousePosition.dx + scrollDelta.dx) -
                      ((mousePosition.dx + scrollDelta.dx) % cellSize);
                  double y = (mousePosition.dy + scrollDelta.dy) -
                      ((mousePosition.dy + scrollDelta.dy) % cellSize);
                  // Delete the item from the placed tiles
                  ref.read(placedTilesProvider.notifier).state.removeWhere(
                    (tile) {
                      return tile.position == Offset(x / 25, y / 25);
                    },
                  );
                }
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
                        width: editingState == EditingState.edit
                            ? selectedTile.size.width * cellSize
                            : cellSize,
                        height: editingState == EditingState.edit
                            ? selectedTile.size.height * cellSize
                            : cellSize,
                        child: selectedTile.file.path != "" &&
                                editingState == EditingState.edit
                            ? Stack(
                                children: [
                                  for (int column = 0;
                                      column <= selectedTile.size.width;
                                      column++)
                                    for (int row = 0;
                                        row <= selectedTile.size.height;
                                        row++)
                                      Positioned(
                                        top: cellSize * row,
                                        left: cellSize * column,
                                        child: SizedBox(
                                          width: cellSize,
                                          height: cellSize,
                                          child: Image.file(selectedTile.file),
                                        ),
                                      ),
                                ],
                              )
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
