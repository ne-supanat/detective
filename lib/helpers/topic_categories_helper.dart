import 'dart:convert';

import 'package:detective/generated/assets.gen.dart';
import 'package:flutter/services.dart';

class TopicCategoriesHelper {
  static List<String> topicCategories = [];

  static loadTopicCategories() async {
    final String jsonString = await rootBundle.loadString(Assets.jsons.topicCategories);
    final Map<String, dynamic> json = Map<String, dynamic>.from(jsonDecode(jsonString));

    topicCategories = List<String>.from(json['data']);
  }
}
