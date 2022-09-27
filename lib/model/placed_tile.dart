import 'dart:io';

import 'package:flutter/material.dart';

class PlacedTile {
  final Offset position;
  final File file;
  final Size size;
  final List<String> flags;

  PlacedTile({
    required this.position,
    required this.size,
    required this.file,
    required this.flags,
  });

  Map<String, dynamic> toJson() => {
        "position": [position.dx, position.dy],
        "file": file.path,
        "size": [size.width, size.height],
        "flags": flags,
      };

  PlacedTile.fromJson(Map<String, dynamic> json)
      : position = Offset(
            json["position"][0] as double, json["position"][1] as double),
        file = File(json["file"] as String),
        size = Size(json["size"][0] as double, json["size"][0] as double),
        flags = (json["flags"] as List).map((flag) => flag.toString()).toList();
}
