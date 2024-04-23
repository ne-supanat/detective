import 'package:detective/helpers/topic_categories_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'generated/l10n.dart';
import 'helpers/sharedpref.dart';
import 'features/gameplay/gameplay_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    await dotenv.load(fileName: ".env");
  }

  await TopicCategoriesHelper.loadTopicCategories();

  await initDI();

  runApp(const MyApp());
}

initDI() async {
  final getIt = GetIt.instance;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPref>(SharedPref(prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const GameplayView(),
    );
  }
}
