import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/json_worker.dart';
import 'package:level_editor/model/editing_state.dart';
import 'package:level_editor/model/placed_tile.dart';
import 'package:level_editor/model/selected_file.dart';

class LevelEditorToolbar extends ConsumerWidget {
  const LevelEditorToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EditingState editingState = ref.watch(editingModeProvider);

    return Positioned(
      top: 30,
      left: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: DARK_BLUE,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(editingModeProvider.notifier).state =
                    EditingState.edit;
              },
              icon: Icon(
                editingState == EditingState.edit
                    ? Icons.edit_rounded
                    : Icons.edit_outlined,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                ref.read(editingModeProvider.notifier).state =
                    EditingState.delete;
              },
              icon: Icon(
                editingState == EditingState.delete
                    ? Icons.delete_rounded
                    : Icons.delete_outline_rounded,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                ref.read(editingModeProvider.notifier).state =
                    EditingState.explore;
              },
              icon: Icon(
                editingState == EditingState.explore
                    ? Icons.explore
                    : Icons.explore_outlined,
              ),
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () async {
                FilePickerResult? pickedFile =
                    await FilePicker.platform.pickFiles(
                  dialogTitle: "Select Level",
                  type: FileType.custom,
                  allowedExtensions: ["json"],
                  allowMultiple: false,
                  lockParentWindow: true,
                );

                if (pickedFile == null || pickedFile.files[0].path == null) {
                  debugPrint("Canceled picker");
                  return;
                }

                Map jsonData =
                    await jsonWorker.loadJSON(pickedFile.files[0].path!);

                ref.read(selectedFilesProvider.notifier).state =
                    (jsonData["selectedFiles"] as List)
                        .map((jsonData) => SelectedFile.fromJson(jsonData))
                        .toList();

                ref.read(placedTilesProvider.notifier).state =
                    (jsonData["tiles"] as List).map((tile) {
                  return PlacedTile.fromJson(tile);
                }).toList();
              },
              icon: const Icon(Icons.get_app_rounded),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () async {
                List<Map<String, dynamic>> selectedFiles = ref
                    .read(selectedFilesProvider.notifier)
                    .state
                    .map((selectedFile) => selectedFile.toJson())
                    .toList();

                // Convert everything to json data
                var jsonList = ref
                    .read(placedTilesProvider.notifier)
                    .state
                    .map((tile) => tile.toJson())
                    .toList();

                Map jsonData = {
                  "title": "Test",
                  "version": 1.0,
                  "selectedFiles": selectedFiles,
                  "tiles": jsonList,
                };

                String? selectedDirectory = await FilePicker.platform.saveFile(
                  dialogTitle: "Save Level",
                  lockParentWindow: true,
                  fileName: "level.json",
                  type: FileType.custom,
                  allowedExtensions: ["json"],
                );

                if (selectedDirectory == null) {
                  debugPrint("Canceled picker");
                  return;
                }
                if (!selectedDirectory.endsWith(".json")) {
                  selectedDirectory += ".json";
                }
                jsonWorker.saveJSON(selectedDirectory, jsonData);
              },
              icon: const Icon(Icons.save_rounded),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
