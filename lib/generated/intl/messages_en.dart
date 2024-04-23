// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(answer) => "A: ${answer}";

  static String m1(question) => "Q: ${question} ?";

  static String m2(mode) => "- ${Intl.select(mode, {
            'true': 'IDENTIFY',
            'false': 'INTERROGATE',
          })} MODE -";

  static String m3(isCorrect) => "The answer is ${Intl.select(isCorrect, {
            'true': '',
            'false': 'not ',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "chat_answer": m0,
        "chat_question": m1,
        "give_up": MessageLookupByLibrary.simpleMessage("Give up"),
        "mode": m2,
        "new_game": MessageLookupByLibrary.simpleMessage("New Game"),
        "note_hint": MessageLookupByLibrary.simpleMessage("Note here..."),
        "note_title": MessageLookupByLibrary.simpleMessage("Note"),
        "notebook": MessageLookupByLibrary.simpleMessage("- NOTEBOOK -"),
        "result": m3,
        "title": MessageLookupByLibrary.simpleMessage("AIdentity"),
        "topic_category_selector_close":
            MessageLookupByLibrary.simpleMessage("close"),
        "topic_category_selector_custom":
            MessageLookupByLibrary.simpleMessage("Custom"),
        "topic_category_selector_custom_add":
            MessageLookupByLibrary.simpleMessage("Add"),
        "topic_category_selector_custom_error":
            MessageLookupByLibrary.simpleMessage("Duplicated category"),
        "topic_category_selector_custom_hint":
            MessageLookupByLibrary.simpleMessage("e.g. Harry Potter"),
        "topic_category_selector_default":
            MessageLookupByLibrary.simpleMessage("Default")
      };
}
