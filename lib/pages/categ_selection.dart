import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/categ_form.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class CategSelectScreen extends StatefulWidget {
  const CategSelectScreen({super.key});

  @override
  State<CategSelectScreen> createState() => _CategSelectScreenState();
}

class _CategSelectScreenState extends State<CategSelectScreen> {
  Stopwatch? _pressTimer;

  @override
  void initState() {
    super.initState();

    NavigationStateSharedPreferences.saveProductPageState('notSelected');
  }

  Widget _loadCategories() {
    if (CategController.savedCategories.isEmpty) {
      return Container(
        width: 340,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 20),
        child: _addButton(),
      );
    }
    return FutureBuilder<List<Categ>?>(
      future: CategPreferencesService.get(),
      builder: (context, AsyncSnapshot<List<Categ>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child:
                      CircularProgressIndicator(color: ThemeColors.primary)));
        } else if (snapshot.hasError) {
          return Text(
              'Ocorreu um erro ao carregar as categorias: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _categoriesList(snapshot.data);
        }
        return Container(
          width: 340,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 20),
          child: _addButton(),
        );
      },
    );
  }

  Widget _categoriesList(List<Categ>? categList) {
    return SizedBox(
      width: 340,
      height: 540,
      child: ListView.builder(
        itemCount: categList!.length,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          if (index + 1 < categList.length) {
            if ((index + 1) % 2 != 0) {
              return Container(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedCategOptions(categList[index + 1]);
                          } else {
                            // Tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemListScreen(
                                        categ: categList[index].title)));
                          }
                        }
                      },
                      /*
                      onLongPress: () =>
                          _selectedCategOptions(categList[index + 1]),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemListScreen(
                                  categ: categList[index + 1].title))),
                      */
                      child: Container(
                        width: 159,
                        height: 165,
                        color: ThemeColors.background,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 150,
                              decoration: BoxDecoration(
                                color: ThemeColors.background,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                      File(categList[index].imgPath!)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                categList[index].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedCategOptions(categList[index + 1]);
                          } else {
                            // Tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemListScreen(
                                        categ: categList[index + 1].title)));
                          }
                        }
                      },
                      /*
                      onLongPress: () =>
                          _selectedCategOptions(categList[index + 1]),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemListScreen(
                                  categ: categList[index + 1].title))),
                      */
                      child: Container(
                        width: 159,
                        height: 165,
                        color: ThemeColors.background,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 120,
                              //width: 150,
                              decoration: BoxDecoration(
                                color: ThemeColors.background,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                      File(categList[index + 1].imgPath!)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                categList[index + 1].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }
          if (categList.isNotEmpty) {
            if (index == 0 || index % 2 == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedCategOptions(categList[index]);
                          } else {
                            // Tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemListScreen(
                                        categ: categList[index].title)));
                          }
                        }
                      },
                      /*
                      onLongPress: () =>
                          _selectedCategOptions(categList[index + 1]),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemListScreen(
                                  categ: categList[index + 1].title))),
                      */
                      child: Container(
                        width: 159,
                        height: 165,
                        color: ThemeColors.background,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 120,
                              width: 150,
                              decoration: BoxDecoration(
                                color: ThemeColors.background,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(
                                      File(categList[index].imgPath!)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                categList[index].title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _addButton(),
                  ],
                ),
              );
            }
          }
          return Container(
            width: 340,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 18),
            child: _addButton(),
          );
        },
      ),
    );
  }

  void _selectedCategOptions(Categ categ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 140,
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  elevation: 0,
                  maximumSize: const Size(200, 100),
                  minimumSize: const Size(190, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategFormScreen(categ: categ))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.edit,
                      size: 36,
                    ),
                    Text(
                      "Editar",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12) // Padding
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  elevation: 0,
                  maximumSize: const Size(200, 100),
                  minimumSize: const Size(190, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmDeleteDialog(categ);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.delete,
                      size: 36,
                    ),
                    Text(
                      "Deletar",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12) // Padding
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteDialog(Categ categ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Excluir Categoria",
            style: TextStyle(
              fontSize: 20,
              // color: ,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            "Tem certeza de que deseja excluir esta categoria? Todos os itens desta categoria serão excluídos.",
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
                "Cancelar",
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Opção: Confirmar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.cancel),
              ),
              onPressed: () {
                setState(() {
                  CategController.delete(categ);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Excluir",
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
      backgroundColor: ThemeColors.backgroundAlt,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          height: double.infinity,
          width: 340,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _unselectedButton(),
                _loadCategories(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _unselectedButton() {
    return SizedBox(
      height: 50,
      width: 340,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ItemListScreen(categ: "")));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ThemeColors.background,
        ),
        child: Text(
          "Todos os Produtos",
          style: GoogleFonts.poppins(
            color: ThemeColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return SizedBox(
      width: 159,
      height: 165,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategFormScreen(categ: null)));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ThemeColors.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 80,
              color: ThemeColors.tertiaryDarkMedium,
            ),
            Text(
              "Nova Categoria",
              style: GoogleFonts.poppins(
                color: ThemeColors.tertiaryDarkMedium,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
