import 'package:detective/generated/l10n.dart';
import 'package:detective/helpers/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<SharedPref>()])
extension WidgetTesterExtension on WidgetTester {
  wrapAndPumpWidget(Widget widget) async {
    await wrapAndPumpPage(Scaffold(body: widget));
  }

  wrapAndPumpPage(Widget widget) async {
    await pumpWidget(
      MaterialApp(
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
        home: widget,
      ),
    );

    await pumpAndSettle();
  }
}
