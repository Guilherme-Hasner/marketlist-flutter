// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class FormFields {
  static Widget label(String label) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label),
    );
  }

  static Widget textField(
      TextEditingController controller, String label, IconData prefixIcon) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: 19.75,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            size: 28,
            color: ThemeColors.secondary,
          ),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 17,
            color: ThemeColors.onContainer,
            fontWeight: FontWeight.w400,
          ),
          fillColor: ThemeColors.container,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  static Widget imagePlaceholder(File? image) {
    if (image == null) {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [8, 8],
        color: ThemeColors.onContainerMedium,
        strokeWidth: 1.65,
        child: Container(
          width: 340,
          height: 190,
          color: ThemeColors.container,
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: ThemeColors.secondary,
                size: 44,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: 300,
                child: Text(
                  "Clique para selecionar uma imagem",
                  style: GoogleFonts.poppins(
                    fontSize: 16.75,
                    color: ThemeColors.onContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: 340,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ThemeColors.container, width: 2),
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  static Widget confirmButtons(
      BuildContext context, Future<bool> altered, void function) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 340,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              FormValidations.execPartialCallBack = true;
              if (!(await altered)) {
                PreviousPageRedirect.redirectProductPage(context);
              } else {
                CustomPopUps.dialog(
                  context,
                  "cancelForm",
                  "Continuar",
                  "Confirmar",
                  PreviousPageRedirect.redirectProductPage(context),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.neutral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(width: 52),
                Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.background,
                  ),
                ),
                Container(
                  width: 52,
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    'assets/images/cancel.svg',
                    color: ThemeColors.background,
                    height: 33,
                    width: 33,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 340,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              FormValidations.execCallBack = true;
              if (await altered) {
                function;
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(width: 52),
                Text(
                  "Salvar",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.background,
                  ),
                ),
                Container(
                  width: 52,
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.save_outlined,
                    color: ThemeColors.background,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPopUps {
  static void editDeleteModal(
      BuildContext context, void redirectEdit, void deleteDialog) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => redirectEdit,
              child: const Column(
                children: <Widget>[Icon(Icons.edit), Text("Editar")],
              ),
            ),
            ElevatedButton(
              onPressed: () => deleteDialog,
              child: const Column(
                children: <Widget>[Icon(Icons.delete), Text("Deletar")],
              ),
            ),
          ],
        );
      },
    );
  }

  static void dialog(BuildContext context, String action, String cancel,
      String confirm, void function) {
    String title = "";
    Widget? dialogTitle;
    String content = "";
    switch (action) {
      case 'deleteCateg':
        title = "Excluir Categoria";
        content = "Tem certeza de que deseja excluir esta categoria?";
        break;
      case 'deleteItem':
        title = "Excluir Item";
        content = "Tem certeza de que deseja excluir este item?";
        break;
      case 'cancelForm':
        content =
            "Todas as suas alterações serão perdidas, tem certeza de que deseja voltar sem salvar?";
        break;
    }
    if (title != "") {
      dialogTitle = Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          // color: ,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: dialogTitle,
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              // color: ,
            ),
          ),
          actions: <Widget>[
            // Opcão: Cancelar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.neutral),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: Text(
                cancel,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            // Opção: Confirmar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.cancel),
              ),
              onPressed: () {
                function;
                Navigator.of(context).pop();
              },
              child: Text(
                confirm,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
