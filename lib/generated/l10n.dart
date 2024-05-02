// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `AIdentity`
  String get title {
    return Intl.message(
      'AIdentity',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `- {mode, select, true{IDENTIFY} false{INTERROGATE}} MODE -`
  String mode(bool mode) {
    return Intl.message(
      '- ${Intl.select(mode, {
            'true': 'IDENTIFY',
            'false': 'INTERROGATE'
          })} MODE -',
      name: 'mode',
      desc: '',
      args: [mode],
    );
  }

  /// `New Game`
  String get new_game {
    return Intl.message(
      'New Game',
      name: 'new_game',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{} =1{1 character} other{{count} characters}}`
  String answer_hint(int count) {
    return Intl.plural(
      count,
      zero: '',
      one: '1 character',
      other: '$count characters',
      name: 'answer_hint',
      desc: '',
      args: [count],
    );
  }

  /// `Give up`
  String get give_up {
    return Intl.message(
      'Give up',
      name: 'give_up',
      desc: '',
      args: [],
    );
  }

  /// `- NOTEBOOK -`
  String get notebook {
    return Intl.message(
      '- NOTEBOOK -',
      name: 'notebook',
      desc: '',
      args: [],
    );
  }

  /// `Q: {question} ?`
  String chat_question(Object question) {
    return Intl.message(
      'Q: $question ?',
      name: 'chat_question',
      desc: '',
      args: [question],
    );
  }

  /// `A: {response}`
  String chat_response(Object response) {
    return Intl.message(
      'A: $response',
      name: 'chat_response',
      desc: '',
      args: [response],
    );
  }

  /// `The answer is {isCorrect, select, true{} false{not }}`
  String result(bool isCorrect) {
    return Intl.message(
      'The answer is ${Intl.select(isCorrect, {'true': '', 'false': 'not '})}',
      name: 'result',
      desc: '',
      args: [isCorrect],
    );
  }

  /// `Answer is {answer}`
  String chat_answer(Object answer) {
    return Intl.message(
      'Answer is $answer',
      name: 'chat_answer',
      desc: '',
      args: [answer],
    );
  }

  /// `No reply.`
  String get chat_no_reply {
    return Intl.message(
      'No reply.',
      name: 'chat_no_reply',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reply, Please ask something else...`
  String get chat_failed_to_reply {
    return Intl.message(
      'Failed to reply, Please ask something else...',
      name: 'chat_failed_to_reply',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note_title {
    return Intl.message(
      'Note',
      name: 'note_title',
      desc: '',
      args: [],
    );
  }

  /// `Note here...`
  String get note_hint {
    return Intl.message(
      'Note here...',
      name: 'note_hint',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get topic_category_selector_custom {
    return Intl.message(
      'Custom',
      name: 'topic_category_selector_custom',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get topic_category_selector_default {
    return Intl.message(
      'Default',
      name: 'topic_category_selector_default',
      desc: '',
      args: [],
    );
  }

  /// `close`
  String get topic_category_selector_close {
    return Intl.message(
      'close',
      name: 'topic_category_selector_close',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Harry Potter`
  String get topic_category_selector_custom_hint {
    return Intl.message(
      'e.g. Harry Potter',
      name: 'topic_category_selector_custom_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get topic_category_selector_custom_add {
    return Intl.message(
      'Add',
      name: 'topic_category_selector_custom_add',
      desc: '',
      args: [],
    );
  }

  /// `Duplicated category`
  String get topic_category_selector_custom_error {
    return Intl.message(
      'Duplicated category',
      name: 'topic_category_selector_custom_error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
