import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/constants.dart';
import 'package:level_editor/model/selected_file.dart';

class PropertieEditorDialog extends ConsumerStatefulWidget {
  final int index;
  const PropertieEditorDialog({Key? key, required this.index})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PropertieEditorDialogState();
}

class _PropertieEditorDialogState extends ConsumerState<PropertieEditorDialog> {
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController flagsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    widthController.dispose();
    heightController.dispose();
    flagsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SelectedFile> selectedFiles = ref.watch(selectedFilesProvider);

    return SimpleDialog(
      backgroundColor: DARK_BLUE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(16),
      title: const Text(
        "Edit Properties",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TileSizeInputField(
              text: "Width: ",
              textEditingController: widthController,
            ),
            TileSizeInputField(
              text: "Height: ",
              textEditingController: heightController,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: const [
            SizedBox(width: 4),
            Text(
              "Flags:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          height: 150,
          width: 400,
          decoration: BoxDecoration(
            color: SELECTED_BLUE,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: flagsController,
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter flags with "," seperated, " " will be ignored',
              hintStyle: TextStyle(
                color: BLUE.withOpacity(0.3),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            if (widthController.text == "") {
              widthController.text = "1";
            }
            if (heightController.text == "") {
              heightController.text = "1";
            }

            selectedFiles[widget.index].setSize(
              Size(
                double.parse(widthController.text.toString()),
                double.parse(heightController.text.toString()),
              ),
            );
            selectedFiles[widget.index].setFlags(
              flagsController.text.toString().replaceAll(" ", "").split(","),
            );
            ref.read(selectedFilesProvider.notifier).state = selectedFiles;
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TileSizeInputField extends StatelessWidget {
  final String text;
  final TextEditingController textEditingController;
  const TileSizeInputField({
    super.key,
    required this.text,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 7.5,
        ),
        SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: textEditingController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "1",
              hintStyle: TextStyle(
                color: SELECTED_BLUE,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
