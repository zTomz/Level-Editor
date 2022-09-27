import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/model/selected_tile.dart';
import 'package:level_editor/widgets/pop_up_menu_item_tile.dart';

class TilePlaceBar extends ConsumerStatefulWidget {
  const TilePlaceBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TilePlaceBarState();
}

class _TilePlaceBarState extends ConsumerState<TilePlaceBar> {
  bool active = true;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<File> selectedFiles = ref.watch(selectedFilesProvider);
    SelectedTile selectedTile = ref.watch(selectedTileProvider);

    return Positioned(
      right: 0,
      top: active
          ? (size.height / 2) - ((size.height - 100) / 2)
          : (size.height / 2) - 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Container(
              width: 30,
              height: 60,
              decoration: const BoxDecoration(
                color: DARK_BLUE,
              ),
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    active = !active;
                  });
                },
                child: Center(
                  child: Icon(
                    active
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (active)
            Container(
              width: 300,
              height: size.height - 100,
              padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
              decoration: const BoxDecoration(
                color: DARK_BLUE,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Images",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'jpeg'],
                          );

                          if (result != null) {
                            ref.read(selectedFilesProvider.notifier).state = [
                              ...ref.read(selectedFilesProvider.notifier).state,
                              ...result.paths
                                  .map((path) => File(path!))
                                  .toList()
                            ];
                          } else {
                            // User canceled the picker
                          }
                        },
                        icon: const Icon(Icons.folder_rounded),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedTileProvider.notifier).state =
                                SelectedTile(
                              size: const Size(1, 1),
                              index: index,
                              file: selectedFiles[index],
                              flags: [],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedTile.index == index
                                  ? SELECTED_BLUE
                                  : DARK_BLUE,
                            ),
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.file(
                                      selectedFiles[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: PopupMenuButton(
                                    tooltip: "Menu",
                                    initialValue: -1,
                                    onSelected: (int selectedIndex) {
                                      if (selectedIndex == 1) {
                                        ref
                                            .read(
                                                selectedFilesProvider.notifier)
                                            .state
                                             = selectedFiles.where((file) => file != selectedFiles[index]).toList();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.settings_rounded,
                                      color: Colors.white,
                                    ),
                                    position: PopupMenuPosition.under,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: SELECTED_BLUE,
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<int>>[
                                      const PopupMenuItem(
                                        value: 0,
                                        child: PopUpMenuTile(
                                          text: "Edit Properties",
                                          icon: Icons.edit_attributes_rounded,
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 1,
                                        child: PopUpMenuTile(
                                          text: "Delete",
                                          icon: Icons.delete_forever_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
