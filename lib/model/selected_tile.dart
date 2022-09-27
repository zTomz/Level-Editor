import 'dart:io';

import 'package:flutter/animation.dart';

class SelectedTile {
  final Size size;
  final int index;
  final File file;
  final List<String> flags;

  SelectedTile({
    required this.size,
    required this.index,
    required this.file,
    required this.flags,
  });
}
