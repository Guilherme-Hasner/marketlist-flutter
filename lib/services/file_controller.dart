// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileController {
  static String appDirectory = Directory.current.path.replaceAll('/', '\\');
  static const String imgsPath = 'assets\\images\\saved';

  static Future<void> save(File arquivo, String nomeArquivo) async {
    final pathImagem = '$appDirectory$imgsPath$nomeArquivo';
    await arquivo.copy(pathImagem);
  }

  static Future<void> delete(String nomeArmazenamento) async {
    File arquivo = File('$appDirectory$imgsPath$nomeArmazenamento');
    await arquivo.delete();
  }

  static Future<void> rename(String nomeArmazenamento, String novoNome) async {
    File arquivo = File('$appDirectory$imgsPath$nomeArmazenamento');
    await arquivo.rename('$appDirectory$imgsPath$novoNome');
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

  static Future<bool> compareFiles(
      BuildContext context, String savedImgPath, File formFile) async {
    try {
      final file1 = File('$appDirectory$imgsPath$savedImgPath');
      final file2 = formFile;
      final dataFile1 = await file1.readAsBytes();
      final dataFile2 = await file2.readAsBytes();

      if (dataFile1.length != dataFile2.length) {
        return false; // Os arquivos tem tamanhos diferentes
      }

      for (int i = 0; i < dataFile1.length; i++) {
        if (dataFile1[i] != dataFile2[i]) {
          return false; // Os arquivos divergem
        }
      }
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(content: Text("Erro ao processar imagem.")),
      );
      return false;
    }
  }
}
