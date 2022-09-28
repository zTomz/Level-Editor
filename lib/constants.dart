// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_editor/model/editing_state.dart';
import 'package:level_editor/model/placed_tile.dart';
import 'package:level_editor/model/selected_tile.dart';

import 'model/selected_file.dart';

const BLUE = Color(0xFFa2d2ff);
const GREEN = Color(0xFF57cc99);
const DARK_BLUE = Color(0xFF003049);
const SELECTED_BLUE = Color(0xFF00293D);

final scrollDeltaProvider = StateProvider<Offset>((ref) => const Offset(0, 0));
final mousePositionProvider =
    StateProvider<Offset>((ref) => const Offset(0, 0));

/* Modes
edit = place tiles
explore = scroll through the level
delete = delete items in the level
*/
final editingModeProvider =
    StateProvider<EditingState>((ref) => EditingState.edit);
final placedTilesProvider = StateProvider<List<PlacedTile>>((ref) => []);
final selectedTileProvider = StateProvider(
  (ref) => SelectedTile(
    size: const Size(1, 1),
    index: -1,
    file: File(""),
    flags: [],
  ),
);
final selectedFilesProvider = StateProvider<List<SelectedFile>>((ref) => []);
final cellSizeProvider = StateProvider<double>((ref) => 25);
