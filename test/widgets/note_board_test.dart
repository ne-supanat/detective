import 'package:detective/widget/note_board.dart';
import 'package:detective/widget/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

void main() {
  group('note board test', () {
    testWidgets('initial element', (WidgetTester tester) async {
      const noteBoard = NoteBoard();

      await tester.wrapAndPumpWidget(noteBoard);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.cleaning_services_rounded), findsOneWidget);
    });

    testWidgets('manage notes', (WidgetTester tester) async {
      const noteBoard = NoteBoard();

      await tester.wrapAndPumpWidget(noteBoard);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(NoteItem), findsOneWidget);

      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
      }
      await tester.pumpAndSettle();

      expect(find.byType(NoteItem), findsExactly(5));

      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      expect(find.byType(NoteItem), findsExactly(4));

      await tester.tap(find.byIcon(Icons.cleaning_services_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(NoteItem), findsNothing);
    });
  });
}
