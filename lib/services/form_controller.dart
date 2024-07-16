// ignore_for_file: use_build_context_synchronously
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class FormValidations {
  static bool execCallBack = false;
  static bool execPartialCallBack = false;

  static List<String> invalidTitlePartials = [
    'titleEmpty',
    'tooLong',
    'invalidChars',
    'titleInvalid',
    'editOverride',
    'notRegistered'
  ];

  static String titlePartialValidation(String? title) {
    if (title == null || title == "") {
      return "titleEmpty";
    }
    // Reserved titles for validations
    if (invalidTitlePartials.contains(title)) {
      return "titleInvalid";
    }
    // Check for special caracters
    String titlePartial = title.replaceAll(" ", "").toLowerCase();
    RegExp regexPortugues = RegExp(r'[A-Za-záàãéÉêíìÍÌóÓôõç]');
    if (titlePartial.replaceAll(regexPortugues, "") != "") {
      return "invalidChars";
    }
    // Check length
    if (title.length > 30) {
      return "tooLong";
    }
    // Return resumed form to continue validations
    return titlePartial;
  }

  static bool itemAltered(Item item, String title, String? description,
      double price, bool imgAltered) {
    if (imgAltered) return true;
    if (item.title == title) {
      bool descriptionVerif1 = item.description == description;
      bool descriptionVerif2 = (item.description == null && description == "");
      bool descriptionVerif3 = (item.description == "" && description == null);
      if (descriptionVerif1 || descriptionVerif2 || descriptionVerif3) {
        if (item.price.toStringAsFixed(2) == price.toStringAsFixed(2)) {
          return false;
        }
      }
    }
    return true;
  }

  static String formatPrice(double value) {
    double price = fixedDecimals(value, 2);
    String decimals = price.toString().split('.').last;
    String integerPart = price.toString().split('.').first;
    for (int i = decimals.length; i < 2; i++) {
      decimals += "0";
    }
    String temp = "";
    int countThousand = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (countThousand == 3 && (i - 1) != 0) {
        temp += ".";
        countThousand = -1;
      }
      temp += integerPart[i];
      countThousand++;
    }
    String formatedPrice = "R\$ ";
    for (int i = temp.length - 1; i >= 0; i--) {
      formatedPrice += temp[i];
    }
    formatedPrice = '$formatedPrice,$decimals';
    return formatedPrice;
  }

  static double fixedDecimals(double number, int decimals) {
    double roundedNumber = number * pow(10, decimals);
    int temp = roundedNumber.round();
    if (temp == 0) return 0.0;
    roundedNumber = temp / pow(10, decimals);
    return roundedNumber;
  }

  static double convertPriceToDouble(String price) {
    String unformatedPrice = price;
    unformatedPrice = unformatedPrice.replaceAll("R\$", "");
    unformatedPrice = unformatedPrice.replaceAll(" ", "");
    unformatedPrice = unformatedPrice.replaceAll(",", ".");
    double value = double.parse(unformatedPrice);
    return value;
  }

  static void showAlertDialog(BuildContext context, String type) {
    String alert = "";
    switch (type) {
      case "limit":
        alert = "Quantidade máxima atingida.";
        break;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            alert,
            style: const TextStyle(
              fontSize: 16,
              // color: ,
            ),
          ),
          actions: <Widget>[
            // Opcão: Confirmar
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.neutral),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: const Text(
                "Ok",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
