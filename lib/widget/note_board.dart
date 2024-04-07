import 'dart:core';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'note_item.dart';

class NoteBoard extends StatefulWidget {
  const NoteBoard({super.key});

  @override
  State<NoteBoard> createState() => _NoteBoardState();
}

class _NoteBoardState extends State<NoteBoard> {
  int noteRunId = 0;

  List<int> noteIds = [];

  Offset selectedNotedDiffOffset = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: DottedBorder(
                  color: Colors.blueGrey.withOpacity(0.5),
                  strokeWidth: 5,
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  radius: const Radius.circular(24),
                  dashPattern: const [10],
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              ...noteIds.map(
                (e) => NoteItem(
                  key: ValueKey(e),
                  id: e,
                  onMove: _bringNoteFront,
                  onRemove: _removeNote,
                ),
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onNewClue,
                      style: IconButton.styleFrom(backgroundColor: Colors.indigo[50]),
                      icon: const Icon(Icons.add, color: Colors.indigo),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _onClearClue,
                      style: IconButton.styleFrom(backgroundColor: Colors.red[50]),
                      icon: const Icon(Icons.cleaning_services_rounded, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _bringNoteFront(int id) {
    setState(() {
      noteIds.remove(id);
      noteIds.add(id);
    });
  }

  _removeNote(int id) {
    setState(() {
      noteIds.remove(id);
    });
  }

  _onNewClue() {
    setState(() {
      noteIds.add(++noteRunId);
    });
  }

  _onClearClue() {
    setState(() {
      noteIds.clear();
    });
  }
}
