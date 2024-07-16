// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:marketlist/pages/categ_selection.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationStateSharedPreferences {

  static Future<void> savePageState(String tabSelected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentTab', tabSelected);
  }

  static Future<String?> getPageState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentTab');
  }

  // If ProductPageState is 'notSelected' a página é CategSelectionScreen, Else é ItemListScreen

  static Future<void> saveProductPageState(String categSelected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('categSelected', categSelected);
  }

  static Future<String?> getProductPageState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('categSelected');
  }
}

class PreviousPageRedirect {
  static void redirectProductPage(BuildContext context) async {
    String? productsPageState =
      await NavigationStateSharedPreferences.getProductPageState();
    if (productsPageState == "notSelected") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CategSelectScreen()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemListScreen(categ: productsPageState!)));
    }
  }
}