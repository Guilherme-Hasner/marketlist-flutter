import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class MarketListScreen extends StatefulWidget {
  const MarketListScreen({super.key});

  @override
  State<MarketListScreen> createState() => _MarketListScreenState();
}

class _MarketListScreenState extends State<MarketListScreen> {
  @override
  void initState() {
    super.initState();
    ItemController.refreshMarketList();
  }

  Widget _marketList() {
    if (ItemController.shopCart.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Text(
          "Sua lista de compras está vazia.",
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 720,
        child: ListView.builder(
          itemCount: ItemController.shopCart.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(ItemController.shopCart[index].title.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 102),
                child: const Icon(Icons.delete_forever_rounded,
                    color: Colors.white),
              ),
              onDismissed: (direction) => null,
              child: Container(
                width: double.infinity,
                height: 176,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: BorderDirectional(
                        bottom:
                            BorderSide(color: ThemeColors.light, width: 2))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                              File(ItemController.shopCart[index].imgPath!)),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 56,
                            child: Text(
                              ItemController.shopCart[index].title,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ThemeColors.secondary,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 44,
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    horizontal:
                                        BorderSide(color: ThemeColors.light))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      ItemController.updateQnt(
                                          ItemController.shopCart[index],
                                          -1,
                                          context);
                                      ItemController.refreshMarketList();
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      padding: const EdgeInsets.all(0),
                                      backgroundColor: ThemeColors.light,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: ThemeColors.secondary,
                                    ),
                                  ),
                                ),
                                Text(
                                  ItemController.shopCart[index].quant
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: ThemeColors.secondary,
                                  ),
                                ),
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      ItemController.updateQnt(
                                          ItemController.shopCart[index],
                                          1,
                                          context);
                                      ItemController.refreshMarketList();
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1,
                                      padding: const EdgeInsets.all(0),
                                      backgroundColor: ThemeColors.light,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: ThemeColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16), // Padding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Total",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.lightGrey,
                                ),
                              ),
                              Text(
                                FormValidations.formatPrice(
                                    ItemController.shopCart[index].price *
                                        ItemController.shopCart[index].quant),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.emphasis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _marketList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
