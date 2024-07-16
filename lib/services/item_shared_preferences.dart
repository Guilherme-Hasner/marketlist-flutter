import 'dart:convert';
import 'package:marketlist/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemPreferencesService {
  static Future<void> save(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString('items', encodedData);
  }

  static Future<List<Item>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final String? items = prefs.getString('items');
    if (items != null && items != '[]') {
      final List<dynamic> decodedData = json.decode(items);
      return decodedData.map((json) => Item.fromJson(json)).toList();
    }
    return [];
  }
}
