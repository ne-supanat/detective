import 'package:detective/widget/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

void main() {
  group('note item test', () {
    testWidgets('initial element', (WidgetTester tester) async {
      final noteItem = NoteItem(
        id: 0,
        onMove: (id) {},
        onRemove: (id) {},
      );

      await tester.wrapAndPumpWidget(Stack(children: [noteItem]));

      expect(find.byIcon(Icons.color_lens_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    });
  });
}
