import 'dart:io';

import 'package:flutter/material.dart';

class SelectedFile {
  final File file;
  Size size;
  List<String> flags;

  SelectedFile({
    required this.file,
    required this.size,
    required this.flags,
  });

  Map<String, dynamic> toJson() => {
        "file": file.path.toString(),
        "size": [size.width, size.height],
        "flags": flags,
      };

  SelectedFile.fromJson(Map<String, dynamic> json)
      : file = File(json["file"] as String),
        size = Size(json["size"][0] as double, json["size"][0] as double),
        flags = (json["flags"] as List).map((flag) => flag.toString()).toList();

  void setSize(Size newSize) {
    size = newSize;
  }

  void setFlags(List<String> newFlags) {
    flags = newFlags;
  }
}
