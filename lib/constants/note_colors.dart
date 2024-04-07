import 'package:flutter/material.dart';

enum NoteColors { yellow, red, green, blue, grey }

extension NoteColorsExtention on NoteColors {
  NoteColors get nextColor {
    switch (this) {
      case NoteColors.yellow:
        return NoteColors.red;
      case NoteColors.red:
        return NoteColors.green;
      case NoteColors.green:
        return NoteColors.blue;
      case NoteColors.blue:
        return NoteColors.grey;
      case NoteColors.grey:
        return NoteColors.yellow;
      default:
        return NoteColors.yellow;
    }
  }

  Color get color {
    switch (this) {
      case NoteColors.yellow:
        return Colors.amber.shade200;
      case NoteColors.red:
        return Colors.red.shade200;
      case NoteColors.green:
        return Colors.green.shade200;
      case NoteColors.blue:
        return Colors.lightBlue.shade200;
      case NoteColors.grey:
        return Colors.grey.shade300;
      default:
        return Colors.yellow.shade300;
    }
  }

  Color get tint {
    switch (this) {
      case NoteColors.yellow:
        return Colors.amber;
      case NoteColors.red:
        return Colors.red.shade400;
      case NoteColors.green:
        return Colors.green.shade400;
      case NoteColors.blue:
        return Colors.lightBlue;
      case NoteColors.grey:
        return Colors.grey;
      default:
        return Colors.yellow;
    }
  }
}
