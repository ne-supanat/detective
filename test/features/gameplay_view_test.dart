import 'package:detective/features/gameplay/gameplay_view.dart';
import 'package:detective/helpers/sharedpref.dart';
import 'package:detective/helpers/topic_categories_helper.dart';
import 'package:detective/widget/topic_category_selector_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../utils.dart';
import '../utils.mocks.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    await TopicCategoriesHelper.loadTopicCategories();
    GetIt.I.registerSingleton<SharedPref>(MockSharedPref());
  });

  group('gameplay view test', () {
    testWidgets('initial element', (WidgetTester tester) async {
      const gameplayView = GameplayView();

      await tester.wrapAndPumpPage(gameplayView);

      expect(find.text('- NOTEBOOK -'), findsOneWidget);
      expect(find.text(TopicCategoriesHelper.topicCategories.first), findsOneWidget);
      expect(find.text('New Game'), findsOneWidget);
    });

    testWidgets('pick category', (WidgetTester tester) async {
      const gameplayView = GameplayView();

      await tester.wrapAndPumpPage(gameplayView);

      await tester.tap(find.text(TopicCategoriesHelper.topicCategories.first));
      await tester.pumpAndSettle();

      expect(find.byType(TopicCategorySelectorDialog), findsOneWidget);

      await tester.tap(find.text(TopicCategoriesHelper.topicCategories.last));
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(find.text(TopicCategoriesHelper.topicCategories.last), findsOneWidget);
    });
  });
}
