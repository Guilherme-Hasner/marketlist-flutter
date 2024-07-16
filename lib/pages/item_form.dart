// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/emulator_API.dart';
import 'package:marketlist/services/file_controller.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;
  final String categ;

  const ItemFormScreen({super.key, required this.item, required this.categ});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  Item? get _item => widget.item;
  String get _categ => widget.categ;

  late bool _newItem;
  String _refTitle = "Novo Item";

  String _imgPath = "";
  File? _image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String _validationMessage = "";

  void _initForm(bool isNew) {
    if (!isNew) {
      _refTitle = _item!.title;
      _title.text = _item!.title;
      _description.text = _item!.description!;
      _price.text = FormValidations.formatPrice(_item!.price);
      _imgPath = _item!.imgPath!;
      _image = File(_imgPath);
    }
  }

  @override
  void initState() {
    super.initState();
    // Se item == null ADD Else EDIT
    _newItem = _item == null;
    _initForm(_newItem);
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
                _monetaryField(_price),
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

  Widget _monetaryField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _price,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyInputFormatter()
        ],
        style: GoogleFonts.poppins(
          fontSize: 19.75,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.monetization_on_outlined,
            size: 28,
            color: ThemeColors.secondary,
          ),
          labelText: "Preço Unitário",
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
                        builder: (context) => ItemListScreen(categ: _categ)));
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
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
          const SizedBox(height: 30), // Padding
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
    return const SizedBox(height: 32); // Padding
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
                        builder: (context) => ItemListScreen(categ: _categ)));
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
    if (_item == null) {
      if (_title.text != "") return true;
      if (_description.text != "") return true;
      if (_price.text != "") return true;
      if (_image != null) return true;
      setState(() {
        _validationMessage = "Preencha todos os campos obrigatórios";
      });
      return false;
    } else {
      if (_title.text != _item!.title) return true;
      if (_description.text != _item!.description) return true;
      if (_price.text != FormValidations.formatPrice(_item!.price)) return true;
      if (_image != null) {
        Future<bool> sameImg =
            FileController.compareFiles(context, _item!.imgPath!, _image!);
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

    String? titleValidation = ItemController.searchAlike(_title.text, _item);
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
      case 'editOverride': // PASS: Resulta em update de _item
        _validationMessage = "pass";
        break;
      case 'notRegistered': // PASS: Título não registrado
        _validationMessage = "pass";
        break;
      case null: // PASS: Nenhum registro, lista vazia
        _validationMessage = "pass";
        break;
      default: // Conflito com Item Existente
        setState(() {
          _validationMessage = "Já existe um item com esse título";
        });
        break;
    }
    if (_validationMessage == "Já existe um item com esse título") return;
    if (_price.text == "") {
      setState(() {
        _validationMessage = "Insira o preço";
      });
      return;
    }
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
    // Salva alterações
    if (_item != null) {
      // Caso seja EDIT remove a instancia salva
      ItemController.delete(_item!);
    }
    // Adiciona nova categoria
    Item newItem = Item(
        categ: _categ,
        title: _title.text,
        description: _description.text,
        price: FormValidations.convertPriceToDouble(_price.text),
        quant: 0,
        imgPath: _image!.path);
    ItemController.insert(newItem);

    // Após salvar categoria redireciona para página anterior
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemListScreen(categ: _categ)),
    );
  }
}
