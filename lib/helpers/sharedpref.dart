import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const customCategoriesKey = 'CUSTOM_CATEGORIES_KEY';

  final SharedPreferences prefs;

  SharedPref(this.prefs);

  Future<void> addNewCustomCategory(String value) async {
    final list = getCustomCategories();
    await prefs.setStringList(customCategoriesKey, list..add(value));
  }

  List<String> getCustomCategories() {
    return prefs.getStringList(customCategoriesKey) ?? [];
  }

  Future<List<String>> removeCustomCategory(String value) async {
    final list = getCustomCategories();
    list.remove(value);
    await prefs.setStringList(customCategoriesKey, list);

    return list;
  }
}
