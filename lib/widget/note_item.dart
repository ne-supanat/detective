import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/note_colors.dart';
import '../generated/l10n.dart';

class NoteItem extends StatefulWidget {
  const NoteItem({super.key, required this.id, this.onMove, this.onRemove});

  final int id;
  final Function(int)? onMove;
  final Function(int)? onRemove;

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  NoteColors color = NoteColors.yellow;
  double _top = 24;
  double _left = 24;

  bool hovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _top,
      left: _left,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              blurRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            color: color.color,
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  color: color.tint.withOpacity(hovering ? 1 : 0.8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        onHover: (hovering) {
                          this.hovering = hovering;
                          setState(() {});
                        },
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            _onMove();

                            _top = max(0, _top + details.delta.dy);
                            _left = max(0, _left + details.delta.dx);

                            setState(() {});
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.menu_rounded,
                              color: Colors.black87,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _buildNoteTextField(
                          maxLines: 1,
                          fontWeight: FontWeight.bold,
                          initialValue: S.of(context).note_title,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          color = color.nextColor;
                          setState(() {});

                          _onMove();
                        },
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.color_lens_outlined,
                          color: Colors.black87,
                          size: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onRemove?.call(widget.id);
                        },
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.black87,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildNoteTextField(
                    minLines: 5,
                    maxLines: 99,
                    hintText: S.of(context).note_hint,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNoteTextField(
      {int? minLines,
      int? maxLines,
      FontWeight? fontWeight,
      String? initialValue,
      String? hintText}) {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: hintText,
      ),
      initialValue: initialValue,
      cursorHeight: 16,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(fontWeight: fontWeight),
      onTap: _onMove,
    );
  }

  _onMove() {
    widget.onMove?.call(widget.id);
  }
}
