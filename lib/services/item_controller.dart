import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/services/file_controller.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/item_shared_preferences.dart';

class ItemController {
  static List<Item> savedItems = [];
  static List<Item> filteredItems = [];
  static List<Item> shopCart = [];

  const ItemController();

  static Future<void> getData() async {
    savedItems = await ItemPreferencesService.get();
  }

  static Future<void> setData() async {
    await ItemPreferencesService.save(savedItems);
  }

  static void filterByCateg(String categTitle) {
    filteredItems =
        savedItems.where((item) => item.categ == categTitle).toList();
  }

  static void removeFilter() {
    filteredItems = savedItems;
  }

  static void refreshMarketList() {
    shopCart = savedItems.where((item) => item.quant > 0).toList();
  }

  // Get is implemented implicitly through FutureBuilder or accessing one of the static lists directly

  static void insert(Item item) {
    savedItems.add(item);
    setData();
  }

  static void update(Item itemOld, Item itemNew) {
    // int index = savedItems.indexOf(itemOld);
    int index = savedItems.indexWhere((i) => i.title == itemOld.title);
    savedItems[index] = itemNew;
    setData();
  }

  static void updateQnt(Item item, int alt, BuildContext context) {
    int newQnt = item.quant + alt;
    if (newQnt > 999) {
      FormValidations.showAlertDialog(context, "limit");
      return;
    }
    Item updatedItem = Item(
        categ: item.categ,
        title: item.title,
        description: item.description,
        price: item.price,
        quant: newQnt,
        imgPath: item.imgPath);
    update(item, updatedItem);
  }

  static void updateCateg(String categOld, String categNew) {
    String categOldSimplified = categOld.replaceAll(' ', '').toLowerCase();
    String categNewSimplified = categNew.replaceAll(' ', '').toLowerCase();
    bool changeImgName = categOldSimplified != categNewSimplified;
    for (int i = 0; i < savedItems.length; i++) {
      // Percorre toda a lista
      if (savedItems[i].categ.replaceAll(' ', '').toLowerCase() ==
          categOldSimplified) {
        // Encontra itens salvos sob a categoria antiga
        String newImgPathName;
        if (changeImgName) {
          // Altera o nome dos arquivos de imagem
          newImgPathName = categNewSimplified +
              savedItems[i].imgPath!.split(categOldSimplified).first;
          FileController.rename(savedItems[i].imgPath!, newImgPathName);
        } else {
          // Não altera o nome do arquivo de imagem
          newImgPathName = savedItems[i].imgPath!;
        }
        Item updatedItem = Item(
            categ: categOld,
            title: savedItems[i].title,
            description: savedItems[i].description,
            price: savedItems[i].price,
            quant: savedItems[i].quant,
            imgPath: newImgPathName);
        savedItems[i] = updatedItem;
      }
    }
    bool update = savedItems.any((x) => x.categ == categOld);
    if (update) {
      setData();
    }
  }

  static void deleteCateg(String categ) {
    savedItems.removeWhere((i) => i.categ == categ);
    setData();
  }

  static void delete(Item item) {
    item = savedItems.lastWhere((i) => i.title == item.title);
    savedItems.remove(item);
    setData();
  }

  static Item? search(String title) {
    int index = savedItems.indexWhere((x) => x.title == title);
    if (index != -1) {
      return savedItems[index];
    }
    return null;
  }

  static String? searchAlike(String? title, Item? edited) {
    String titleSimplified = FormValidations.titlePartialValidation(title);
    // Faz a primeira validação do Form para ver se o título é válido
    if (FormValidations.invalidTitlePartials.contains(titleSimplified)) {
      // Senão for retorna o tipo de invalidez
      return titleSimplified;
    }
    // Verifica se a lista está vazia
    if (savedItems.isNotEmpty) {
      // Senão estiver vazia busca por títulos semelhantes (correspondentes ao tirar espaços brancos e maiúsculas)

      int index = savedItems.indexWhere(
          (x) => x.title.replaceAll(" ", "").toLowerCase() == titleSimplified);
      if (index != -1) {
        // Se achar uma correspondência retornaria o index em String
        if (edited != null) {
          // Mas se Item? edited != null, a correspondência pode ser igual ao item editado, retornando 'editOverride'
          if (edited.title.replaceAll(" ", "").toLowerCase() ==
              titleSimplified) {
            return "editOverride";
          }
        }
        return savedItems[index].toString();
      }
      return "notRegistered";
    }
    // Se a lista estiver vazia retorna null
    return null;
  }
}
