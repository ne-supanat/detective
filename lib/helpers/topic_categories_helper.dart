import 'dart:convert';

import 'package:flutter/services.dart';

class TopicCategoriesHelper {
  static List<String> topicCategories = [];

  static loadTopicCategories() async {
    final String jsonString = await rootBundle.loadString('assets/jsons/topic_categories.json');
    final Map<String, dynamic> json = Map<String, dynamic>.from(jsonDecode(jsonString));

    topicCategories = List<String>.from(json['data']);
  }
}
