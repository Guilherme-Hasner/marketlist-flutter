// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/categ_selection.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/emulator_API.dart';
import 'package:marketlist/services/file_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class CategFormScreen extends StatefulWidget {
  final Categ? categ;

  const CategFormScreen({super.key, this.categ});

  @override
  State<CategFormScreen> createState() => _CategFormScreenState();
}

class _CategFormScreenState extends State<CategFormScreen> {
  Categ? get _categ => widget.categ;
  late bool _newCateg;
  String _refTitle = "Nova Categoria";

  String _imgPath = "";
  File? _image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String _validationMessage = "";

  void _initForm(bool isNew) {
    if (!isNew) {
      _refTitle = _categ!.title;
      _title.text = _categ!.title;
      _description.text = _categ!.description!;
      _imgPath = _categ!.imgPath!;
      _image = File(_imgPath);
    }
  }

  @override
  void initState() {
    super.initState();
    // Se categ == null ADD Else EDIT
    _newCateg = _categ == null;
    _initForm(_newCateg);
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          height: 628,
          width: 340,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20), // Padding
                FormFields.textField(_title, 'Título', Icons.label_outline),
                const SizedBox(height: 14), // Padding
                FormFields.textField(
                    _description, 'Descrição (Opcional)', Icons.short_text),
                const SizedBox(height: 14), // Padding
                GestureDetector(
                  child: FormFields.imagePlaceholder(_image),
                  onTap: () async {
                    var temp = await EmulatorAPI.pickImage(context);
                    setState(() {
                      _image = temp;
                    });
                  },
                ),
                _onValidate(),
                _confirmButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Transplanted from Pages/Widgets
  Widget _confirmButtons() {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 340,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (!(await _checkForAlterations())) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategSelectScreen()));
              } else {
                _confirmCancelDialog();
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
              if (await _checkForAlterations()) {
                _validate();
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

  Widget _onValidate() {
    if (_validationMessage == "pass") {
      // _save();
    } else if (_validationMessage != "") {
      return Column(
        children: <Widget>[
          const SizedBox(height: 39), // Padding
          Container(
            width: 340,
            alignment: Alignment.topLeft,
            child: Text(
              _validationMessage,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: ThemeColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20), // Padding
        ],
      );
    }
    return const SizedBox(height: 80); // Padding
  }

  void _confirmCancelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            "Todas as suas alterações serão perdidas, tem certeza de que deseja voltar sem salvar?",
            style: TextStyle(
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
              child: const Text(
                "Continuar",
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Opção: Confirmar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.cancel),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategSelectScreen()));
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _refTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _form(),
    );
  }

  Future<bool> _checkForAlterations() async {
    /*
    if (FormValidations.execCallBack || FormValidations.execPartialCallBack) {
      FormValidations.execCallBack = false;
      FormValidations.execPartialCallBack = false;
      ...
    }
    */
    if (_categ == null) {
      if (_title.text != "") return true;
      if (_description.text != "") return true;
      if (_image != null) return true;
      setState(() {
        _validationMessage = "Preencha todos os campos obrigatórios";
      });
      return false;
    } else {
      if (_title.text != _categ!.title) return true;
      if (_description.text != _categ!.description) return true;
      if (_image != null) {
        Future<bool> sameImg =
            FileController.compareFiles(context, _categ!.imgPath!, _image!);
        if (await sameImg) return true;
      }
    }
    return false;
  }

  void _validate() async {
    /*
    if (FormValidations.execCallBack) {
      FormValidations.execCallBack = false;
      ...
    }
    */

    String? titleValidation = CategController.searchAlike(_title.text, _categ);
    switch (titleValidation) {
      case 'titleEmpty': // ERRO: Título Inválido
        setState(() {
          _validationMessage = "Insira um título";
        });
        return;
      case 'tooLong': // ERRO: Título Inválido
        setState(() {
          _validationMessage = "Título muito longo";
        });
        return;
      case 'invalidChars': // ERRO: Título Inválido
        setState(() {
          _validationMessage = "Caracter(es) inválidos no título";
        });
        return;
      case 'titleInvalid': // ERRO: Título Inválido
        setState(() {
          _validationMessage = "Título inválido";
        });
        return;
      case 'editOverride': // PASS: Resulta em update de _categ
        _validationMessage = "pass";
        break;
      case 'notRegistered': // PASS: Título não registrado
        _validationMessage = "pass";
        break;
      case null: // PASS: Nenhum registro, lista vazia
        _validationMessage = "pass";
        break;
      default: // Conflito com Categoria Existente
        setState(() {
          _validationMessage = "Já existe uma categoria com esse título";
        });
        break;
    }
    if (_validationMessage == "Já existe uma categoria com esse título") return;
    if (_image == null) {
      // ERRO: Selecione uma imagem
      setState(() {
        _validationMessage = "Selecione uma imagem";
      });
      return;
    }
    if (_validationMessage == "pass") _save();
  }

  void _save() {
    /*
    // Salva imagem
    if (_categ == null) {
      _imgPath = '${_title.text.replaceAll(" ", "").toLowerCase()}.${_image!.path.split('.').last}';
      FileController.save(_image!, _imgPath);
    } else {
      Future<bool> sameImg =
          FileController.compareFiles(context, _categ!.imgPath!, _image!);
      if (await sameImg) {
        if (_categ!.title.replaceAll(" ", "").toLowerCase() !=
            _title.text.replaceAll(" ", "").toLowerCase()) {
          _imgPath = _title.text.replaceAll(" ", "").toLowerCase() +
              _image!.path.split('.').last;
          FileController.rename(_categ!.imgPath!, _imgPath);
        } else {
          _imgPath = _categ!.imgPath!;
        }
      } else {
        _imgPath = '${_title.text.replaceAll(" ", "").toLowerCase()}.${_image!.path.split('.').last}';
        FileController.delete(_categ!.imgPath!);
        FileController.save(_image!, _imgPath);
      }
    }
    */

    // Salva alterações
    if (_categ != null) {
      // Caso seja EDIT remove a instancia salva
      CategController.delete(_categ!);
      // Fazer alterações para itens da categoria editada
      ItemController.updateCateg(_categ!.title, _title.text);
    }
    // Adiciona nova categoria
    Categ newCateg = Categ(
        title: _title.text,
        description: _description.text,
        imgPath: _image!.path);
    CategController.insert(newCateg);

    // Após salvar categoria redireciona para página anterior
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategSelectScreen()),
    );
  }
}
