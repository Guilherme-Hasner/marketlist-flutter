// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class EmulatorAPI {
  static void addImageToGallery(String imgPath) {
    GallerySaver.saveImage(imgPath);
  }

  static Future<File?> pickImage(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nenhuma imagem selecionada.'),
          backgroundColor: Colors.red,
        ));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao selecionar imagem: $e'),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }
}